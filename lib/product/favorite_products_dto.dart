

import 'dto/product_dto.dart';

class FavoriteProductDto {
  final int id;
  final ProductDto product;

  FavoriteProductDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        product = ProductDto.fromJson(json['product']);
}
