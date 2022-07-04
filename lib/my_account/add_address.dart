import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../cart/pincode_dto.dart';
import '../theme/dialog.dart';
import '../theme/primary_button.dart';


class AddAddress extends StatefulWidget {
  static const routeName = '/add-address';

  final Function refreshAddresses;

  AddAddress(this.refreshAddresses);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  double _selectedLatitude = 0;
  double _selectedLongitude = 0;
  Completer<GoogleMapController> _controller = Completer();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  late String _location;
  late String _addr1;
  late String _addr2;
  late int _pin;
  late PincodeDto _selectPincode;
  late List<DropdownMenuItem<dynamic>> _pincodes;
  late List<PincodeDto> _pincodesDetails;

  Future<void> _fetchPincodes() async {
    List<PincodeDto> pincodesList;
    dynamic response = await http.get(urls.pincodes, {});
    pincodesList =
        (response['responseData']['pincodes'] as List<dynamic>).map((value) {
      return PincodeDto.fromJson(value);
    }).toList();

    List<DropdownMenuItem> pincodes = pincodesList.map((e) {
      return DropdownMenuItem(
        child: Text(e.pincode.toString()),
        value: e.pincode,
      );
    }).toList();

    setState(() {
      _pincodes = pincodes;
      _pincodesDetails = pincodesList;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPincodes();
  }

  void _addAddress(BuildContext ctx) {
    if (_location != null && _addr1.isNotEmpty &&
        _selectPincode != null &&
        _selectedLatitude != null &&
        _selectedLongitude != null) {
      showLoader(ctx, title: 'Adding address');
      http.post(
        urls.address,
        {},
        {
          'location': _location,
          'addressLine1': _addr1,
          'addressLine2': _addr2,
          'pincode': _selectPincode.id,
          'latitude': _selectedLatitude,
          'longitude': _selectedLongitude,
        },
      ).then((value) {
        widget.refreshAddresses();
        hideLoader(ctx);
        Navigator.of(context).pop();
      }).catchError((error) {
        hideLoader(ctx);
        displaySnackBarMessage(ctx, 'Something went wrong');
      });
    } else {
      displaySnackBarMessage(ctx, 'All fields are mandatory!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        leading: const BackButton(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          'Add Address',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Builder(
          builder: (ctx) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom) *
                      0.4,
                  child: (_selectedLatitude == null ||
                          _selectedLongitude == null)
                      ? const SizedBox()
                      : GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target:
                                LatLng(_selectedLatitude, _selectedLongitude),
                            zoom: 20,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PrimaryButton(
                            title: 'Change Location',
                            onPressed: () {}
                              //todo create map picker in app
                              // LocationResult result = await showLocationPicker(
                              //   context,
                              //   'AIzaSyAeOrbjYKuUJ_QHaOIiMT3ammJR3IwmD_4',
                              //   myLocationButtonEnabled: true,
                              //   layersButtonEnabled: true,
                              // );
                            //   print("result = $result");
                            //   final GoogleMapController controller =
                            //       await _controller.future;
                            //   setState(() {
                            //     _location = result.address;
                            //     _addressLine1Controller.text = '';
                            //     _addr1 = '';
                            //     _addressLine2Controller.text = '';
                            //     _addr2 = '';
                            //     _selectedLatitude = result.latLng.latitude;
                            //     _selectedLongitude = result.latLng.longitude;
                            //   });
                            //   controller.animateCamera(
                            //     CameraUpdate.newCameraPosition(
                            //       CameraPosition(
                            //         bearing: 0,
                            //         target: LatLng(
                            //           result.latLng.latitude,
                            //           result.latLng.longitude,
                            //         ),
                            //         zoom: 17.0,
                            //       ),
                            //     ),
                            //   );
                            //  },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Set delivery location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if(_location != null)
                        Text('$_location'),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _addressLine1Controller,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          labelText: 'Location',
                          alignLabelWithHint: true,
                          errorStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (value) => _addr1 = value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _addressLine2Controller,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
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
                      if (_pincodes != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            // child: SearchableDropdown.single(
                            //   keyboardType: TextInputType.number,
                            //   items: _pincodes,
                            //   hint: "Delivery pincode",
                            //   searchHint: "Select delivery pincode",
                            //   onChanged: (value) {
                            //     PincodeDto selectedPincode =
                            //         _pincodesDetails.firstWhere(
                            //             (element) => element.pincode == value);
                            //     _pin = value;
                            //     _selectPincode = selectedPincode;
                            //   },
                            //   isExpanded: true,
                            // ),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: ButtonTheme(
                          height: 50,
                          child: PrimaryButton(
                            onPressed: () => _addAddress(ctx),
                            title: 'Add Address',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
