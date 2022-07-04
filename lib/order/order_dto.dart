class OrderDto {
  final double? amount;
  final List<dynamic>? orderItems;

  OrderDto({this.amount, this.orderItems});

  OrderDto.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        orderItems = (json['orderItems'] as List<dynamic>)
            .map((e) => OrderItem.fromJson(e))
            .toList();

  Map<String, dynamic> toMap() {
    return {"amount": this.amount, "orderItems": this.orderItems};
  }
}

class OrderItem {
  final int? productId;
  final int? quantityId;
  int? productQuantity;

  OrderItem({this.productId, this.quantityId, this.productQuantity});

  OrderItem.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        quantityId = json['quantityId'],
        productQuantity = json['productQuantity'];

  Map<String, dynamic> toMap() {
    return {
      "productId": this.productId,
      "quantityId": this.quantityId,
      "productQuantity": this.productQuantity
    };
  }
}
