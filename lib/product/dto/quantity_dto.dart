class QuantityDto {
  final int id;
  final String unit;
  final double price;
  final int quantity;

  QuantityDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        unit = json['unit'],
        price = json['price'],
        quantity = json['quantity'];
}
