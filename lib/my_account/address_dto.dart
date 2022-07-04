

import '../cart/pincode_dto.dart';

class AddressDto {
  int id;
  String location;
  String addressLine1;
  String addressLine2;
  PincodeDto pincode;
  double latitude;
  double longitude;

  AddressDto(this.id, this.location, this.addressLine1, this.addressLine2, this.latitude, this.longitude, this.pincode);

  AddressDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        location = json['location'],
        addressLine1 = json['addressLine1'],
        addressLine2 = json['addressLine2'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        pincode = PincodeDto.fromJson(json['pincode']);
}
