import 'package:flutter/material.dart';

import '../common_widget/cached_image.dart';
import '../product/dto/product_dto.dart';


class BasketProductItem extends StatelessWidget {
  final ProductDto productDto;

  BasketProductItem(this.productDto);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: CachedImage(
            url: productDto.image,
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${productDto.name}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${productDto.planDetails!.quantity} ${productDto.planDetails!.unit}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${productDto.planDetails!.points} Points',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
