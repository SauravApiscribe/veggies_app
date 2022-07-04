import 'package:flutter/material.dart';

import '../common_widget/cached_image.dart';
import 'basket_details.dart';
import 'basket_dto.dart';


class Basket extends StatelessWidget {
  final BasketDto basketDto;
  final bool isOneTimeBasket;

  Basket(this.basketDto, this.isOneTimeBasket);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => BasketDetails(basketDto, isOneTimeBasket)));
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: CachedImage(
                  url: basketDto.image,
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${basketDto.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${basketDto.points} Points',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${basketDto.deliveries} Deliveries',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${basketDto.price}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => BasketDetails(basketDto, isOneTimeBasket)));
                            },
                            child: Text(isOneTimeBasket ? 'BUY' : 'SUBSCRIBE'),
                                                     ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
