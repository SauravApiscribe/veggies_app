import 'package:flutter/material.dart';


class SelectDeliveryAddress extends StatefulWidget {
  final String addressOne;
  final String addressTwo;
  final int pincode;
  final List<DropdownMenuItem<int>> items;
  final Function setAddress;
  final Color backgroundColor;

  SelectDeliveryAddress(this.addressOne, this.addressTwo, this.pincode,
      this.items, this.setAddress, {required this.backgroundColor});

  @override
  _SelectDeliveryAddressState createState() => _SelectDeliveryAddressState();
}

class _SelectDeliveryAddressState extends State<SelectDeliveryAddress> {
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  late String _addr1;
  late String _addr2;
  late int _pin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: widget.backgroundColor ?? Colors.lightBlue.shade50,
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          color: Colors.blue.shade900,
        ),
        title: Text(
          'SET DELIVERY LOCATION',
          style: TextStyle(
            color: Colors.blue.shade900,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.blue.shade900,
        ),
        onTap: () {
         showDialog(
            useSafeArea: true,
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'SET DELIVERY ADDRESS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Builder(
                builder: (ctx) => SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width - MediaQuery.of(context).padding.left - MediaQuery.of(context).padding.right,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Select Delivery Location',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 2,
                          controller: _addressLine1Controller,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Flat/Block No.',
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onChanged: (value) => _addr1 = value,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 2,
                          controller: _addressLine2Controller,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Area/Landmark',
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onChanged: (value) => _addr2 = value,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child:const  Padding(
                            padding: EdgeInsets.all(10),
                            // child: SearchableDropdown.single(
                            //   keyboardType: TextInputType.number,
                            //   items: widget.items,
                            //   value: widget.pincode,
                            //   hint: "Delivery pincode",
                            //   searchHint: "Select delivery pincode",
                            //   onChanged: (value) => _pin = value,
                            //   isExpanded: true,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actionsOverflowButtonSpacing: 20,
              actions: [
                FlatButton(
                  child: Text(
                    'Cancel',
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    _addressLine1Controller.clear();
                    _addressLine2Controller.clear();
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    'Set',
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    widget.setAddress(_addr1, _addr2, _pin);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String? validateTextInput(value, error) {
    if (value.isEmpty) {
      return error;
    }
    return null;
  }
}
