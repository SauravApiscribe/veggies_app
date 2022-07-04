import 'package:flutter/material.dart';

import '../my_account/address_dto.dart';


class SelectedDeliveryAddress extends StatelessWidget {
  final AddressDto selectedAddress;
  final Color backgroundColor;

  SelectedDeliveryAddress(this.selectedAddress, {required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Colors.lightBlue.shade50,
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          color: Colors.blue.shade900,
        ),
        title: Text(
          'Delivery Location',
          style: TextStyle(
            color: Colors.blue.shade900,
          ),
        ),
        subtitle: Text(
          '${selectedAddress.addressLine1} , ${selectedAddress.addressLine2},  ${selectedAddress.pincode.pincode}',
          style: TextStyle(
            color: Colors.blue.shade900,
          ),
        ),
      ),
    );
  }
}
