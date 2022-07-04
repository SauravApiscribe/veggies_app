class PincodeDto {
  final double deliveryCharges;
  final int id;
  final int pincode;
  final List<dynamic> slots;
  final int deliveryDays;

  PincodeDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deliveryCharges = json['deliveryCharges'],
        pincode = json['pincode'],
        deliveryDays = json['deliveryDays'],
        slots = (json['slot'] as List<dynamic>)
            .map((e) => Slot.fromJson(e))
            .toList();
}

class Slot {
  final int id;
  final int day;
  final String start;
  final String end;

  Slot.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        day = json['day'],
        start = json['start_time'],
        end = json['end_time'];
}
