import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common_widget/cached_image.dart';
import '../order/order_dto.dart';
import '../product/dto/product_dto.dart';


class CustomizeBasketRow extends StatefulWidget {
  final ProductDto product;
  final Function setProductMapValue;
  final bool isSelected;
  final OrderItem orderItem;
  final Function addProductQuantity;
  final Function removeProductQuantity;

  CustomizeBasketRow(
    this.product,
    this.setProductMapValue,
    this.isSelected,
    this.orderItem,
    this.addProductQuantity,
    this.removeProductQuantity,
  );

  @override
  _CustomizeBasketRowState createState() => _CustomizeBasketRowState();
}

class _CustomizeBasketRowState extends State<CustomizeBasketRow> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    setState(() {
      isChecked = widget.isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                CachedImage(
                  height: 50,
                  width: 50,
                  url: widget.product.image,
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.product.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${widget.product.planDetails!.quantity} ${widget.product.planDetails!.unit}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Move to widget
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: isChecked
                            ? () =>
                                widget.removeProductQuantity(widget.product.id)
                            : null,
                      ),
                      Text(
                        widget.orderItem == null
                            ? '0'
                            : '${widget.orderItem.productQuantity}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: isChecked
                            ? () => widget.addProductQuantity(widget.product.id)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 4,
              ),
              Text(
                (widget.orderItem != null)
                    ? '${widget.orderItem.productQuantity! * widget.product.planDetails!.points} Points'
                    : '${widget.product.planDetails!.points} Points',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Checkbox(
                activeColor: Theme.of(context).primaryColor,
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = !isChecked;
                  });
                  widget.setProductMapValue(widget.product.id, isChecked);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
