import 'package:flutter/material.dart';

import '../product/dto/product_dto.dart';
import 'add_to_cart_popup.dart';


class AddToCartButton extends StatelessWidget {
  final ProductDto productDto;

  AddToCartButton(this.productDto);

  void _showAddToCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      builder: (bctx) {
        return GestureDetector(
          onTap: () {},
          child: AddToCartPopup(productDto),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showAddToCartModal(context),
      child: Text('ADD'),

    );
  }
}
