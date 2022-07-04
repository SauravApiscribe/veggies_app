
import '../product/dto/product_dto.dart';
import '../product/dto/quantity_dto.dart';

class PreviousOrder {
  final int id;
  final int createdOn;
  final String orderId;
  final String paymentId;
  final String status;
  final double totalAmount;
  final CouponDto? couponDto;
  final List<dynamic> items;

  PreviousOrder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdOn = json['createdOn'],
        orderId = json['orderId'],
        paymentId = json['paymentId'],
        status = json['status'],
        totalAmount = json['totalAmount'],
        couponDto = (json['coupon'] != null) ? CouponDto.fromJson(json['coupon']) : null,
        items = (json['items'] as List<dynamic>)
            .map((e) => PreviousOrderItem.fromJson(e))
            .toList();
}

class PreviousOrderItem {
  final int id;
  final int orderQuantity;
  final ProductDto product;
  final QuantityDto quantity;

  PreviousOrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        orderQuantity = json['orderQuantity'],
        product = ProductDto.fromJson(json['product']),
        quantity = QuantityDto.fromJson(json['quantity']);
}

class CouponDto {
  final String couponCode;
  final double price;

  CouponDto.fromJson(Map<String, dynamic> json)
      : couponCode = json['couponCode'],
        price = json['price'];
}
