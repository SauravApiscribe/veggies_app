import 'package:flutter/material.dart';

import '../product/dto/quantity_dto.dart';


class QuantitySelect extends StatefulWidget {
  final QuantityDto selectedQuantity;
  final QuantityDto quantityToShow;
  final Function updateSelectedQuantity;

  QuantitySelect(
      {required this.selectedQuantity,
      required this.quantityToShow,
      required this.updateSelectedQuantity});

  @override
  _QuantitySelectState createState() => _QuantitySelectState();
}

class _QuantitySelectState extends State<QuantitySelect> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Radio(
        activeColor: Colors.green,
        value: widget.quantityToShow,
        groupValue: widget.selectedQuantity,
        onChanged: (value) {
          widget.updateSelectedQuantity(value);
        },
      ),
      title: Text(
        '${widget.quantityToShow.quantity} ${widget.quantityToShow.unit}',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
