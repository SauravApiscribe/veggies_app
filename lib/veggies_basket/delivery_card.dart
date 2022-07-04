import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common_widget/cached_image.dart';
import '../order/previous_order_dto.dart';
import '../theme/primary_button.dart';
import 'basket_dto.dart';
import 'customize_basket.dart';
import 'delivery_dto.dart';

class DeliveryCard extends StatefulWidget {
  final DeliveryDto deliveryDetails;
  final BasketDto basketDetails;

  DeliveryCard(this.deliveryDetails, this.basketDetails);

  @override
  _DeliveryCardState createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<DeliveryCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 3),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery No.: ${widget.deliveryDetails.deliveryNo}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    '${widget.deliveryDetails.status} - ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.deliveryDetails.deliveryDate))}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text('Edit start time - '),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${DateFormat('dd-MM-yyyy hh:mm aa').format(DateTime.fromMillisecondsSinceEpoch(widget.deliveryDetails.customizationStartDate))}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Edit end time -   '),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${DateFormat('dd-MM-yyyy hh:mm aa').format(DateTime.fromMillisecondsSinceEpoch(widget.deliveryDetails.customizationEndDate))}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.basketDetails.isOneTimeDelivery
                      ? SizedBox()
                      : PrimaryButton(
                          title: 'Edit',
                          onPressed:(){ isCustamizable(
                                  widget.deliveryDetails.customizationStartDate,
                                  widget.deliveryDetails.customizationEndDate)
                              ?
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CustomiseBasket(
                                              widget.deliveryDetails,
                                              widget.basketDetails))):null;
                                }
                        ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              isExpanded
                  ? Column(
                      children: [
                        getProducts(
                            'Basket Products', widget.deliveryDetails.products as List<PreviousOrderItem>),
                        getProducts('Additional Products',
                            widget.deliveryDetails.extraProducts as List<PreviousOrderItem>),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  bool isCustamizable(int custamizationStartDate, int custamizationEndDate) {
    return (DateTime.now().toUtc().millisecondsSinceEpoch >
            custamizationStartDate &&
        DateTime.now().toUtc().millisecondsSinceEpoch < custamizationEndDate);
  }

  Widget getProducts(String title, List<PreviousOrderItem> products) {
    if (products.length == 0) {
      return SizedBox();
    }
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          color: Colors.black,
        ),
        ...products.map(
          (e) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CachedImage(
                      height: 25,
                      width: 25,
                      url: e.product.image,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        '${e.product.name} ${e.quantity.quantity} ${e.quantity.unit} * ${e.orderQuantity}'),
                  ],
                ),
                title == 'Products'
                    ? Text(
                        '${e.orderQuantity * e.product.planDetails!.points} Points')
                    : Text('₹ ${e.quantity.price * e.orderQuantity}'),
              ],
            );
          },
        ).toList(),
      ],
    );
  }
}
