import 'package:flutter/material.dart';
import 'package:veggies_app/cart/quantity_select.dart';

import '../product/dto/product_dto.dart';
import '../product/dto/quantity_dto.dart';
import '../theme/dialog.dart';
import '../theme/secondary_button.dart';
import 'cart_service.dart';


class AddToCartPopup extends StatefulWidget {
  final ProductDto productDto;

  AddToCartPopup(this.productDto);

  @override
  _AddToCartPopupState createState() => _AddToCartPopupState();
}

class _AddToCartPopupState extends State<AddToCartPopup> {
  late QuantityDto _selectedQuantity;

  void _updateSelectedQuantity(updatedQuantity) {
    setState(() {
      _selectedQuantity = updatedQuantity;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedQuantity = widget.productDto.quantities[0];
    });
  }

  void _addToCart(BuildContext context) async {
    await CartService.addToCart(
        widget.productDto.id.toString(), _selectedQuantity.id.toString());
    Navigator.of(context).pop();
    displayToastMessage('${widget.productDto.name} added to your cart', color: Colors.orange);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.lightBlue.shade50.withOpacity(0.4),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.productDto.name}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '₹${_selectedQuantity.price} per ${_selectedQuantity.quantity} ${_selectedQuantity.unit}',
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Select Quantity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: widget.productDto.quantities.map((variant) {
                        return QuantitySelect(
                          selectedQuantity: _selectedQuantity,
                          quantityToShow: variant,
                          updateSelectedQuantity: _updateSelectedQuantity,
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    color: Colors.green.shade400,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Item Total - ₹${_selectedQuantity.price}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          SecondaryButton(
                            title: 'ADD ITEM',
                            onPressed: () => _addToCart(context),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
