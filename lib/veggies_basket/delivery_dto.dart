

import '../cart/pincode_dto.dart';
import '../order/previous_order_dto.dart';
import 'basket_dto.dart';

class DeliveriesDto {
  final BasketDto basketDetails;
  final List<dynamic> deliveries;

  DeliveriesDto.fromJson(Map<String, dynamic> json)
      : basketDetails = BasketDto.fromJson(json['basket']),
        deliveries = (json['deliveries'] as List<dynamic>)
            .map((e) => DeliveryDto.fromJson(e))
            .toList();
}

class DeliveryDto {
  final int id;
  final int deliveryNo;
  final int customizationStartDate;
  final int customizationEndDate;
  final int deliveryDate;
  final int maxPoints;
  final List<PreviousOrderItem> products;
  final List<PreviousOrderItem> extraProducts;
  final Slot slot;
  final String status;

  DeliveryDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deliveryNo = json['deliveryNo'],
        customizationStartDate = json['customizationStartDate'],
        customizationEndDate = json['customizationEndDate'],
        deliveryDate = json['deliveryDate'],
        maxPoints = json['maxPoints'],
        products = (json['products'] as List<dynamic>)
            .map((e) => PreviousOrderItem.fromJson(e))
            .toList(),
        extraProducts = (json['extraProducts'] as List<dynamic>)
            .map((e) => PreviousOrderItem.fromJson(e))
            .toList(),
        slot = Slot.fromJson(json['slot']),
        status = json['status'];
}
