import 'package:flutter/material.dart';

import '../product/dto/product_dto.dart';
import '../product/product.dart';


class TopSaversBlock extends StatelessWidget {
  final List<dynamic> topSaverProducts;
  final String period;

  TopSaversBlock(this.topSaverProducts, this.period);

  @override
  Widget build(BuildContext context) {
    return topSaverProducts.length == 0
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top Savers of the $period',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: topSaverProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  return Product(topSaverProducts[index]);
                },
              ),
              SizedBox(
                height: 15,
              )
            ],
          );
  }
}
