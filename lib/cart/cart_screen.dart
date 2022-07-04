import 'package:flutter/material.dart';

import '../helpers/shared_preferences_helper.dart';
import '../my_account/user_dto.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../onborading/login.dart';
import '../product/dto/product_dto.dart';
import '../product/dto/quantity_dto.dart';
import '../theme/dialog.dart';
import '../theme/full_screen_loader.dart';
import 'cart_item.dart';
import 'cart_service.dart';
import 'checkout_screen.dart';


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Map<String, dynamic> _cart;
  late List<ProductDto> _products;
  late double _totalCartAmount;
  double _deliveryCharges = 0;

  @override
  void initState() {
    super.initState();
    _fetchCartDetails();
  }

  Future<void> _addToCart(String productId, String variantId) async {
    await CartService.addToCart(productId, variantId);
    _fetchCartDetails();
  }

  Future<void> _removeFromCart(String productId, String variantId,
      {int quantity = 1}) async {
    await CartService.removeFromCart(productId, variantId, quantity);
    _fetchCartDetails();
  }

  Future<Map<String, dynamic>> _fetchCartDetails() async {
    var cartResponse = await CartService.getCartDetails();
    List<String> productIds = [];
    cartResponse.keys.forEach((key) {
      productIds.add(CartService.getProductIdFromKey(key));
    });
    List<String> uniqueProductIds = productIds.toSet().toList();

    List<ProductDto> products;
    dynamic response = await http
          .get('${urls.products}?id=${uniqueProductIds.join(",")}', {});
      products =
          (response['responseData']['products'] as List<dynamic>).map((value) {
        return ProductDto.fromJson(value);
      }).toList();


    double total = 0;
    List<String> keysTobeRemovedFromCart = [];
    cartResponse.forEach((key, value) {
      var productId = CartService.getProductIdFromKey(key);
      var variantId = CartService.getVariantIdFromKey(key);
      ProductDto productDetails = products
          .firstWhere((element) => int.parse(productId) == element.id && element.inStock,
      );
      QuantityDto? variantDetails = null;
      if(productDetails != null) {
        variantDetails = productDetails
            .quantities
            .firstWhere((element) => int.parse(variantId) == element.id,
            );
      }

      if (productDetails == null || variantDetails == null) {
        keysTobeRemovedFromCart.add(key);
        CartService.removeVariantFromCart(key);
      } else {
        total = total + (variantDetails.price * value);
      }
    });

    keysTobeRemovedFromCart.forEach((key) => cartResponse.remove(key));

    setState(() {
      _cart = cartResponse;
      _products = products;
      _totalCartAmount = total;
    });

    return cartResponse;
  }

  ProductDto getProduct(String productId) {
    return _products
        .firstWhere((element) => int.parse(productId) == element.id);
  }

  void _clearCart() {
    SharedPreferencesHelper.removeValue(SharedPreferencesHelper.cart);
    _fetchCartDetails();
  }

  void resendVerificationEmail(BuildContext ctx) async {
    Navigator.of(context).pop();
    showLoader(ctx, title: 'Resending mail');
    UserDto userDetails = await SharedPreferencesHelper.getUserDetails();
    http.post(urls.signup, {}, {
      'resend': true,
      'mobile': userDetails.mobile,
    }).then((value) {
      hideLoader(ctx);
      displayToastMessage('Resent verification email!', color: Colors.orange);
    }).catchError((error) {
      hideLoader(ctx);
      Navigator.of(context).pop();
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_cart != null && _products != null)
        ? Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        ..._cart.entries.map((e) {
                          var productId =
                              CartService.getProductIdFromKey(e.key);
                          var variantId =
                              CartService.getVariantIdFromKey(e.key);
                          return CartItem(getProduct(productId), variantId,
                              e.value, _addToCart, _removeFromCart);
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
              /*Divider(
                color: Colors.grey,
              ),
              BillDetails(_totalCartAmount, _deliveryCharges),
              SizedBox(
                height: 5,
              ),*/
              FutureBuilder<UserDto>(
                future: SharedPreferencesHelper.getUserDetails(),
                builder: (BuildContext ctx, AsyncSnapshot<UserDto> snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  }
                  /*if (!snapshot.data.doesHoldMembership) {
                    return Container(
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'You need to buy basket membership first!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }*/
                  /*return Column(
                    children: [
                      (_userSelectedAddress != null)
                          ? SelectedDeliveryAddress(_userSelectedAddress)
                          : SizedBox(),
                      CartFooter(
                        cartAmount: _totalCartAmount + _deliveryCharges,
                        cart: _cart,
                        clearCart: _clearCart,
                        isBasket: false,
                      ),
                    ],
                  );*/
                  return Container(
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total amount: ₹${_totalCartAmount + _deliveryCharges}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                            child: Text(
                              'Checkout',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () async {
                              UserDto userDetails =
                                  await SharedPreferencesHelper
                                      .getUserDetails();
                              if (userDetails.token.isEmpty) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    Login.routeName,
                                    (Route<dynamic> route) => false);
                              } else {
                                if(_totalCartAmount <= 0) {
                                  displaySnackBarMessage(context, 'Add products to cart before checkout.');
                                } else {
                                  var response = await http.get(urls.signup, {});
                                  SharedPreferencesHelper.setMembershipFlag(
                                      response['responseData']['user']
                                      ['doesHoldMembership']);
                                  SharedPreferencesHelper.setIsEmailVerified(
                                      response['responseData']['user']
                                      ['isEmailVerified']);
                                  userDetails = await SharedPreferencesHelper
                                      .getUserDetails();
                                  if (!userDetails.isEmailVerified) {
                                    displayMessageWithAction(
                                        context,
                                        'It seems like you have not verified email yet.\n\nResend verification mail?',
                                            () => resendVerificationEmail(ctx));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CheckoutScreen(
                                          cartAmount:
                                          _totalCartAmount + _deliveryCharges,
                                          cart: _cart,
                                          clearCart: _clearCart,
                                          isBasket: false,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            },

                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        : (_cart != null && _cart.length == 0)
            ? Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            : FullScreenLoader();
  }
}
