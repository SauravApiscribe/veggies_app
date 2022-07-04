

import '../product/dto/product_dto.dart';

class BasketDto {
  final int id;
  final int deliveries;
  final String image;
  final String name;
  final int points;
  final double price;
  final bool isOneTimeDelivery;
  final List<dynamic> description;
  final List<dynamic> products;

  BasketDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deliveries = json['deliveries'],
        image = json['image'],
        name = json['name'],
        points = json['points'],
        price = json['price'],
        isOneTimeDelivery = json['isOneTimeDelivery'],
        description = (json['description'] as List<dynamic>),
        products = (json['products'] as List<dynamic>).map((e) {
          return ProductDto.fromJson(e);
        }).toList();
}

class VeggiesDto {
  final List<dynamic> basketDto;
  final String image;
  final List<dynamic> howItWorks;
  final List<dynamic> oneTimeBasket;

  VeggiesDto.fromJson(Map<String, dynamic> json)
      : basketDto = (json['baskets'] as List<dynamic>).map((e) {
          return BasketDto.fromJson(e);
        }).toList(),
        image = json['image'],
        oneTimeBasket = (json['oneTimeBasket'] as List<dynamic>).map((e) {
          return BasketDto.fromJson(e);
        }).toList(),
        howItWorks = (json['sections'][0]['How It Work'] as List<dynamic>);
}
