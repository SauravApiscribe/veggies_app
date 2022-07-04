import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:veggies_app/order/previous_order_dto.dart';

import '../common_widget/cached_image.dart';
import 'chat/chat_screen.dart';


class PreviousOrderCard extends StatefulWidget {
  final PreviousOrder previousOrder;

  PreviousOrderCard(this.previousOrder);

  @override
  _PreviousOrderCardState createState() => _PreviousOrderCardState();
}

class _PreviousOrderCardState extends State<PreviousOrderCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${widget.previousOrder.orderId}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.previousOrder.createdOn))} ${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.previousOrder.createdOn))}',
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (widget.previousOrder.couponDto != null)
                      ? Row(
                          children: [
                            Text(
                              '₹${widget.previousOrder.totalAmount + widget.previousOrder.couponDto!.price}',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '₹${widget.previousOrder.totalAmount}',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          '₹${widget.previousOrder.totalAmount}',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  Row(
                    children: [
                      (widget.previousOrder.status == 'SUCCESS')
                          ? Icon(
                              Icons.done,
                              color: Colors.green,
                              size: 16,
                            )
                          : Icon(
                              Icons.clear,
                              color: Colors.red,
                              size: 16,
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${widget.previousOrder.status}',
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
                      )
                    ],
                  ),
                ],
              ),
              if(widget.previousOrder.couponDto != null)
                Text(
                  'Coupon applied!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Do you have any issues with order?',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ChatScreen(widget.previousOrder.id)));
                    },
                    child: Text('Contact Us'),

                  ),
                ],
              ),
              isExpanded
                  ? Column(
                      children: widget.previousOrder.items.map((e) {
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
                            Text('₹ ${e.quantity.price * e.orderQuantity}'),
                          ],
                        );
                      }).toList(),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
