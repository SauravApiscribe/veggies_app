import 'package:flutter/material.dart';

import '../common_widget/cached_image.dart';
import '../product/dto/product_dto.dart';
import '../product/dto/quantity_dto.dart';


class CartItem extends StatelessWidget {
  final ProductDto productDto;
  final String variantId;
  final int cartQuantity;
  final Function addToCart;
  final Function removeFromCart;

  CartItem(this.productDto, this.variantId, this.cartQuantity, this.addToCart,
      this.removeFromCart);

  QuantityDto getQuantityDetails(String variantId) {
    return productDto.quantities
        .firstWhere((element) => int.parse(variantId) == element.id);
  }

  @override
  Widget build(BuildContext context) {
    var quantityDetails = getQuantityDetails(variantId);
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedImage(
                  url: productDto.image,
                  height: 50,
                  width: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productDto.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "₹ ${quantityDetails.price} / ${quantityDetails.quantity} ${quantityDetails.unit}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Move to widget
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () =>
                      removeFromCart(productDto.id.toString(), variantId),
                ),
                Text(
                  cartQuantity.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () =>
                      addToCart(productDto.id.toString(), variantId),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹ ${quantityDetails.price * cartQuantity}',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          /*IconButton(
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => removeFromCart(
              productDto.id.toString(), variantId,
              quantity: cartQuantity),
        ),*/
        ],
      ),
    );
  }
}
