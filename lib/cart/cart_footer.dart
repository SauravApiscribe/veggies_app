import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../exception/generic_exception.dart';
import '../helpers/shared_preferences_helper.dart';
import '../my_account/address_dto.dart';
import '../my_account/user_dto.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../order/order_dto.dart';
import '../theme/dialog.dart';
import '../util/constants.dart';
import 'cart_service.dart';


class CartFooter extends StatefulWidget {
  final double? cartAmount;
  final Map<String, dynamic>? cart;
  final Function? clearCart;
  final bool? isBasket;
  final bool? isOnetimeBasket;
  final int? basketId;
  final int? slot;
  final Function? refreshBasketDetails;
  final bool? isWithBasket;
  final AddressDto? addressDto;
  final bool? isNewAddress;
  final String? couponCode;

  CartFooter({
    this.cartAmount,
    this.cart,
    this.clearCart,
    this.isBasket,
    this.isOnetimeBasket,
    this.basketId,
    this.slot,
    this.refreshBasketDetails,
    this.isWithBasket,
    this.addressDto,
    this.isNewAddress,
    this.couponCode,
  });

  @override
  _CartFooterState createState() => _CartFooterState();
}

class _CartFooterState extends State<CartFooter> {
  Razorpay _razorpay = Razorpay();
  late String orderId;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _openCheckout(BuildContext ctx) async {
    showLoader(ctx, title: 'Placing order..');
    createOrder(ctx);
  }

  Future<void> createOrder(BuildContext ctx) async {
    if(widget.cartAmount! <= 0) {
      displaySnackBarMessage(context, 'Invalid amount');
      return;
    }

    List<OrderItem> orderItems = [];
    if (!widget.isBasket!) {
      widget.cart!.forEach(
        (key, value) {
          var productId = CartService.getProductIdFromKey(key);
          var variantId = CartService.getVariantIdFromKey(key);
          orderItems.add(
            OrderItem(
              productId: int.parse(productId),
              quantityId: int.parse(variantId),
              productQuantity: value,
            ),
          );
        },
      );
    }

    var address = widget.isNewAddress!
        ? {
            'isNew': true,
            'location': widget.addressDto!.location,
            'addressLine1': widget.addressDto!.addressLine1,
            'addressLine2': widget.addressDto!.addressLine2,
            'latitude': widget.addressDto!.latitude,
            'longitude': widget.addressDto!.longitude,
            'pincode': widget.addressDto!.pincode.id,
          }
        : {
            'isNew': false,
            'id': widget.addressDto!.id,
          };

    var postOrderBody = widget.isBasket!
        ? {
            'amount': widget.cartAmount,
            'orderType': 'BASKET',
            'slot': widget.slot,
            'basket': widget.basketId,
            'address': address,
            if (widget.couponCode!.isNotEmpty) 'coupon': widget.couponCode,
          }
        : widget.isWithBasket!
            ? {
                'amount': widget.cartAmount,
                'withBasket': true,
                if (widget.couponCode!.isNotEmpty) 'coupon': widget.couponCode,
                'orderItems': orderItems
                    .map((e) => {
                          'productId': e.productId,
                          'quantityId': e.quantityId,
                          'productQuantity': e.productQuantity,
                        })
                    .toList(),
              }
            : {
                'amount': widget.cartAmount,
                'withBasket': false,
                if (widget.couponCode!.isNotEmpty) 'coupon': widget.couponCode,
                'address': address,
                'orderItems': orderItems
                    .map((e) => {
                          'productId': e.productId,
                          'quantityId': e.quantityId,
                          'productQuantity': e.productQuantity,
                        })
                    .toList(),
              };

    http
        .post(urls.order, {}, postOrderBody)
        .then((value) {
          hideLoader(ctx);
          orderId = value['responseData']['order']['orderId'];
          _openRazorpay(orderId);
        })
        .catchError((e) => _handleGenericException(e, ctx),
            test: (e) => e is GenericException)
        .catchError((error) {
          hideLoader(ctx);
          displaySnackBarMessage(ctx, 'Something went wrong');
        });
  }

  void _handleGenericException(e, ctx) {
    hideLoader(ctx);
    displaySnackBarMessage(ctx, 'Something went wrong');
  }

  void _openRazorpay(String orderId) async {
    UserDto userDto = await SharedPreferencesHelper.getUserDetails();
    var options = {
      'key': razorpay_key,
      'order_id': orderId,
      'amount': (widget.cartAmount! * 100),
      'name': appName,
      'description': checkout_description,
      'prefill': {'contact': userDto.mobile, 'email': userDto.email ?? ''},
      'theme': {
        'color': '#008000',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      displayToastMessage('Error: ${e.toString()}');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.of(context).pop();
    if (!widget.isBasket!) {
      widget.clearCart!();
    } else {
      if (!widget.isOnetimeBasket!) {
        SharedPreferencesHelper.setMembershipFlag(true)
            .then((value) => widget.refreshBasketDetails!());
      }
    }
    String successMessage = payment_success;
    if (widget.isBasket!) {
      successMessage = basket_success;
    } else if (!widget.isWithBasket!) {
      successMessage = payment_success_without_basket;
    }
    showPaymentPopupMessage(context, true, successMessage);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showPaymentPopupMessage(context, false, payment_failure);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    displayToastMessage(
        'You have chosen to pay via : ${response.walletName}. It will take some time to reflect your basket membership status.');
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total amount: ₹${widget.cartAmount}',
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
                onPressed: () => _openCheckout(ctx),

              )
            ],
          ),
        ),
      ),
    );
  }
}
