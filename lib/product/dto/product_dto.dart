

import 'package:veggies_app/product/dto/quantity_dto.dart';

class ProductDto {
  final int id;
  final String name;
  final String description;
  final String image;
  final bool inStock;
  final bool isFavorite;
  final bool show;
  final String unit;
  final double mrp;
  final double price;
  final PlanDetails? planDetails;
  final List<dynamic> healthBenefits;
  final List<dynamic> nutritionBenefits;
  final List<QuantityDto> quantities;

  ProductDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        image = json['image'],
        inStock = json['inStock'],
        isFavorite = json['isFavorite'] ?? true,
        show = json['show'],
        unit = json['unit'],
        mrp = json['mrp'],
        price = json['price'],
        planDetails = (json['planDetails'] != null) ? PlanDetails.fromJson(json['planDetails']) : null,
        healthBenefits = (json['healthBenefits'] as List<dynamic>),
        nutritionBenefits = (json['nutritionBenefits'] as List<dynamic>),
        quantities = (json['quantities'] as List<dynamic>)
            .map((e) => QuantityDto.fromJson(e))
            .toList();
}

class PlanDetails {
  final int id;
  final int points;
  final int quantity;
  final String unit;

  PlanDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        points = json['points'],
        quantity = json['quantity'],
        unit = json['unit'];
}
