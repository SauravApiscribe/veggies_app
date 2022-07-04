import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../exception/generic_exception.dart';
import '../helpers/shared_preferences_helper.dart';
import '../my_account/user_dto.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../order/order_dto.dart';
import '../product/dto/product_dto.dart';
import '../theme/dialog.dart';
import '../util/constants.dart';
import 'basket_dto.dart';
import 'customize_basket_row.dart';
import 'delivery_dto.dart';


class CustomiseBasket extends StatefulWidget {
  final DeliveryDto deliveryDetails;
  final BasketDto basketDetails;

  CustomiseBasket(this.deliveryDetails, this.basketDetails);

  @override
  _CustomiseBasketState createState() => _CustomiseBasketState();
}

class _CustomiseBasketState extends State<CustomiseBasket> {
  Map<int, bool?> selectedProductsMap = {};
  int? _usedPoints = 0;
  int? _initialUsedPoints = 0;
  List<OrderItem> _orderItems = [];
  double _pricePerPoint = 1;
  late String orderId;
  Razorpay _razorpay = Razorpay();

  void setProductMapValue(int productId, bool isChecked) {
    selectedProductsMap.update(productId, (value) => isChecked);
    int? updatedUsedPoints = 0;
    OrderItem orderItem = getOrderItemByProduct(productId);
    ProductDto product = getProductById(productId);
    if (isChecked) {
      if (orderItem == null) {
        _orderItems.add(OrderItem(
          productId: productId,
          quantityId: product.planDetails!.id,
          productQuantity: 1,
        ));
      }
      orderItem = getOrderItemByProduct(productId);
      updatedUsedPoints = (_usedPoints! +
          (orderItem.productQuantity! *
              widget.basketDetails.products
                  .firstWhere((prod) => prod.id == productId)
                  .planDetails
                  .points)) as int?;
    } else {
      updatedUsedPoints = (_usedPoints! -
          (orderItem.productQuantity! *
              widget.basketDetails.products
                  .firstWhere((prod) => prod.id == productId)
                  .planDetails
                  .points)) as int?;
    }
    setState(() {
      _usedPoints = updatedUsedPoints!;
    });
  }

  ProductDto getProductById(int productId) {
    return widget.basketDetails.products
        .firstWhere((prod) => prod.id == productId);
  }

  OrderItem getOrderItemByProduct(int productId) {
    return _orderItems.firstWhere((prod) => prod.productId == productId,);
  }

  void addProductQuantity(int productId) {
    OrderItem orderItem = getOrderItemByProduct(productId);
    if (orderItem == null) {
      ProductDto product = getProductById(productId);
      _orderItems.add(OrderItem(
        productId: productId,
        quantityId: product.planDetails!.id,
        productQuantity: 1,
      ));
    } else {
      orderItem.productQuantity = orderItem.productQuantity! + 1;
    }
    _usedPoints = (_usedPoints! +
        widget.basketDetails.products
            .firstWhere((prod) => prod.id == productId)
            .planDetails
            .points) as int?;
    setState(() {});
  }

  void removeProductQuantity(int productId) {
    OrderItem orderItem = getOrderItemByProduct(productId);
    if (orderItem != null) {
      if (orderItem.productQuantity == 1) {
        _orderItems.remove(orderItem);
      } else {
        orderItem.productQuantity = orderItem.productQuantity! - 1;
      }
      _usedPoints = (_usedPoints! -
          widget.basketDetails.products
              .firstWhere((prod) => prod.id == productId)
              .planDetails
              .points) as int?;
    }
    setState(() {});
  }

  void _fetchPricePerPoint() async {
    http.get(
      urls.priceperpoint,
      {},
    ).then((response) {
      var pricePerPoint = response['responseData']['pricePerPoint']['price'];
      setState(() {
        _pricePerPoint = pricePerPoint;
      });
    }).catchError((error) {
      print('Error');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchPricePerPoint();
    widget.basketDetails.products.forEach((product) {
      selectedProductsMap.putIfAbsent(product.id, () {
        List productIdsInDelivery =
            widget.deliveryDetails.products.map((e) => e.product.id).toList();
        if (productIdsInDelivery.contains(product.id)) {
          return true;
        }
        return false;
      });
    });
    int? usedPoints = 0;
    List<OrderItem> orderItems = [];
    widget.deliveryDetails.products.forEach((product) {
      orderItems.add(OrderItem(
        productId: product.product.id,
        quantityId: product.product.planDetails!.id,
        productQuantity: product.orderQuantity,
      ));
      usedPoints = (usedPoints! +
          (product.orderQuantity * product.product.planDetails!.points)) as int?;
    });

    setState(() {
      _usedPoints = usedPoints;
      _initialUsedPoints = usedPoints;
      _orderItems = orderItems ?? [];
    });
  }

  void _custamizeOrder(BuildContext ctx) {
    displayConfirmationMessage(
        ctx,
        'Are you sure you want to custamize this order?',
        () => _confirmCustamize(ctx));
  }

  List<OrderItem> getCheckedOrderItems() {
    List<OrderItem> checkedOrderItems = _orderItems
        .where((orderItem) => selectedProductsMap[orderItem.productId]!)
        .toList();
    checkedOrderItems.forEach((orderItem) {
      print(
          '${orderItem.productId} - ${orderItem.quantityId} - ${orderItem.productQuantity}');
    });
    return checkedOrderItems;
  }

  void _confirmCustamize(ctx) {
    List<OrderItem> checkedOrderItems = getCheckedOrderItems();
    if (checkedOrderItems.length == 0) {
      return;
    }

    var putOrderBody = {
      'orderItems': checkedOrderItems
          .map((e) => {
                'productId': e.productId,
                'quantityId': e.quantityId,
                'productQuantity': e.productQuantity,
              })
          .toList(),
    };

    http
        .put(
      urls.delivery + '${widget.deliveryDetails.id}/',
      {},
      putOrderBody,
    )
        .then((value) {
      hideLoader(ctx);
      displayToastMessage('Basket customization successful!',
          color: Colors.orange);
      print(value);
      Navigator.of(context).pop();
    }).catchError((error) {
      hideLoader(ctx);
      displaySnackBarMessage(ctx, 'Something went wrong');
    });
  }

  void _confirmCustamizeAndPay(BuildContext ctx) {
    displayConfirmationMessage(
        ctx, 'Confirm basket customization and Pay?', () => _createOrder(ctx));
  }

  void _createOrder(BuildContext ctx) {
    List<OrderItem> checkedOrderItems = getCheckedOrderItems();
    var putOrderBody = {
      'orderItems': checkedOrderItems
          .map((e) => {
                'productId': e.productId,
                'quantityId': e.quantityId,
                'productQuantity': e.productQuantity,
              })
          .toList(),
    };

    showLoader(ctx, title: 'Almost there!');
    http
        .put(
      urls.delivery + '${widget.deliveryDetails.id}/',
      {},
      putOrderBody,
    )
        .then((response) {
      print(response);
      if (getPayForPoints() * _pricePerPoint > 0) {
        var postOrderBody = {
          'amount': getPayForPoints() * _pricePerPoint,
          'withBasket': true,
          'extendedDeliveryId': response['responseData']['delivery']['id'],
          'orderItems': checkedOrderItems
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
      } else {
        hideLoader(ctx);
        onBasketCustamizationSuccess();
      }
    }).catchError((error) {
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
      'amount': (getPayForPoints() * _pricePerPoint * 100),
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
    onBasketCustamizationSuccess();
  }

  void onBasketCustamizationSuccess() {
    displayToastMessage('Basket customization successful!',
        color: Colors.orange);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    displayToastMessage('Basket customization failed!', color: Colors.red);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onBasketCustamizationSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        leading: BackButton(),
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'My Basket',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Builder(
        builder: (ctx) => SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Column(
                      children: widget.basketDetails.products
                          .map(
                            (e) => CustomizeBasketRow(
                              e,
                              setProductMapValue,
                              selectedProductsMap[e.id]!,
                              getOrderItemByProduct(e.id),
                              addProductQuantity,
                              removeProductQuantity,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                color: isValidcheckAfterExtraPayNotRemovingItems()
                    ? Theme.of(context).primaryColor
                    : Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _initialUsedPoints! <= widget.deliveryDetails.maxPoints
                              ? 'Points: $_usedPoints / ${widget.deliveryDetails.maxPoints}'
                              : 'Points: $_usedPoints / ${widget.deliveryDetails.maxPoints} + ${_initialUsedPoints! - widget.deliveryDetails.maxPoints}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        ElevatedButton(
                          onPressed:
                              !isValidcheckAfterExtraPayNotRemovingItems()
                                  ? null
                                  : checkUsedPointsLessThanMaxPoints()
                                      ? () => _custamizeOrder(ctx)
                                      : () => _confirmCustamizeAndPay(ctx),
                          child: Text(
                            checkUsedPointsLessThanMaxPoints()
                                ? 'Confirm'
                                : 'Confirm and Pay',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),

                        ),
                      ],
                    ),
                    isValidcheckAfterExtraPayNotRemovingItems()
                        ? checkUsedPointsLessThanMaxPoints()
                            ? SizedBox()
                            : Text(
                                'Pay for ${getPayForPoints()} points (${getPayForPoints() * _pricePerPoint} Rs.).',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              )
                        : SizedBox(),
                    isValidcheckAfterExtraPayNotRemovingItems()
                        ? SizedBox()
                        : Text(
                            'You can\'t remove items for which you have already paid now.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkUsedPointsLessThanMaxPoints() =>
      _usedPoints! <= widget.deliveryDetails.maxPoints;

  bool isValidcheckAfterExtraPayNotRemovingItems() {
    if (_initialUsedPoints! > widget.deliveryDetails.maxPoints &&
        _usedPoints! < _initialUsedPoints!) {
      return false;
    }
    return true;
  }

  int getPayForPoints() {
    if (_initialUsedPoints! > widget.deliveryDetails.maxPoints) {
      return _usedPoints! - _initialUsedPoints!;
    }
    return _usedPoints! - widget.deliveryDetails.maxPoints;
  }
}
