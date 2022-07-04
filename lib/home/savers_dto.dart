

import '../product/dto/product_dto.dart';

class SaversDto {
  List<dynamic> daily;
  List<dynamic> weekly;

  SaversDto.fromJson(Map<String, dynamic> json)
      : daily = (json['daily'] as List<dynamic>)
            .map((e) => ProductDto.fromJson(e['product']))
            .toList(),
        weekly = (json['weekly'] as List<dynamic>)
            .map((e) => ProductDto.fromJson(e['product']))
            .toList();
}
