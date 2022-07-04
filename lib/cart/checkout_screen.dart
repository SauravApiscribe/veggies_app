import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:veggies_app/cart/pincode_dto.dart';
import 'package:veggies_app/cart/select_delivery_slot.dart';

import '../helpers/shared_preferences_helper.dart';
import '../my_account/address_dto.dart';
import '../my_account/user_dto.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../theme/dialog.dart';
import '../theme/primary_button.dart';
import 'apply_coupon.dart';
import 'bill_details.dart';
import 'cart_footer.dart';


class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  final double? cartAmount;
  final Map<String, dynamic>? cart;
  final Function? clearCart;
  final bool? isBasket;
  final bool? isOnetimeBasket;
  final int? basketId;
  final int? slot;

  final Function? refreshBasketDetails;

  CheckoutScreen({
    this.cartAmount,
    this.cart,
    this.clearCart,
    this.isBasket,
    this.isOnetimeBasket,
    this.basketId,
    this.slot,
    this.refreshBasketDetails,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  ScrollController _scrollController = new ScrollController();
  Completer<GoogleMapController> _controller = Completer();
  late List<AddressDto> _userAddresses;
  double _deliveryCharges = 0;
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  late String _location;
  late String _addr1;
  late String _addr2;
  late int _pin;
  late List<DropdownMenuItem<dynamic>> _pincodes;
  late List<PincodeDto> _pincodesDetails;
  double _selectedLatitude = 0;
  double _selectedLongitude = 0;
  late int _selectedSlot;
  late PincodeDto _selectPincode;
  bool _isWithoutBasket = false;
  int _selectedAddressId = 0;
  bool _isNewAddress = true;
  bool _isDeliveryCheckboxEditable = true;
  double discountPrice = 0;
  String couponCode = '';

  Future<void> _fetchUserAddress() async {
    dynamic response = await http.get(urls.address, {});
    if ((response['responseData']['addresses'] as List<dynamic>).isNotEmpty) {
      List<AddressDto> userAddresses =
          (response['responseData']['addresses'] as List<dynamic>)
              .map((e) => AddressDto.fromJson(e))
              .toList();
      setState(() {
        _userAddresses = userAddresses;
      });
    }
  }

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

  void _fetchUserDetails() async {
    UserDto userDto = await SharedPreferencesHelper.getUserDetails();
    if (!userDto.doesHoldMembership || widget.isOnetimeBasket!) {
      setState(() {
        _isWithoutBasket = true;
        _isDeliveryCheckboxEditable = false;
      });
    }
  }

  void _applyCouponCode(String code, BuildContext ctx) {
    print(code);
    showLoader(ctx, title: 'Applying code');
    http.put(
      urls.coupon + '$code/',
      {},
      {'apply': true},
    ).then((response) {
      hideLoader(ctx);
      if (!response['responseData']['canApply']) {
        displaySnackBarMessage(ctx, response['responseData']['message']);
      } else {
        displayToastMessage(
          'Coupon code applied!',
          color: Colors.orange,
        );
        setState(() {
          couponCode = code;
          discountPrice = response['responseData']['price'];
        });
      }
    }).catchError((error) {
      hideLoader(ctx);
      displaySnackBarMessage(ctx, 'Invalid coupon code');
    });
  }

  void _clearCouponCode() {
    setState(() {
      couponCode = '';
      discountPrice = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
    _fetchPincodes();
    _fetchUserDetails();
  }

  void setSelectedSlot(int value) {
    print('Selected slot: $value');
    setState(() {
      _selectedSlot = value;
    });
  }

  void _savedAddresses() {
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
              width: MediaQuery.of(context).size.width -
                  MediaQuery.of(context).padding.left -
                  MediaQuery.of(context).padding.right,
              child: (_userAddresses == null)
                  ? Text('You don\'t have any saved addresses')
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Saved Address',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ..._userAddresses.map((e) {
                          return InkWell(
                            onTap: () async {
                              setState(() {
                                _selectedLatitude = e.latitude;
                                _selectedLongitude = e.longitude;
                                _location = e.location;
                                _addr1 = e.addressLine1;
                                _addr2 = e.addressLine2;
                                _addressLine1Controller.text = e.addressLine1;
                                _addressLine2Controller.text = e.addressLine2;
                                _pin = e.pincode.pincode;
                                _selectedAddressId = e.id;
                                _isNewAddress = false;
                                _selectPincode = e.pincode;
                                _selectedSlot = e.pincode.slots[0].id;
                              });
                              final GoogleMapController controller =
                                  await _controller.future;

                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    bearing: 0,
                                    target: LatLng(
                                      e.latitude,
                                      e.longitude,
                                    ),
                                    zoom: 17.0,
                                  ),
                                ),
                              );
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 500),
                              );

                              Navigator.of(context).pop();
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.location_on,
                              ),
                              title: Text(' ${e.location}'),
                              subtitle: Text(
                                '${e.addressLine1}, ${e.addressLine2}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateCheckout() {
    print((_location != null && _addr1.isNotEmpty && _selectPincode != null));
    //return true;
    return (_location != null && _addr1.isNotEmpty && _selectPincode != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        leading: BackButton(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Builder(
          builder: (ctx) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom) *
                            0.4,
                        child: (_selectedLatitude == null ||
                                _selectedLongitude == null)
                            ? SizedBox()
                            : GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      _selectedLatitude, _selectedLongitude),
                                  zoom: 20,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ///todo create map  picker in flutter
                                // PrimaryButton(
                                //   title: 'Change Location',
                                //   onPressed: () async {
                                //     LocationResult result =
                                //         await showLocationPicker(
                                //       context,
                                //       'AIzaSyAeOrbjYKuUJ_QHaOIiMT3ammJR3IwmD_4',
                                //       myLocationButtonEnabled: true,
                                //       layersButtonEnabled: true,
                                //     );
                                //     print("result = $result");
                                //     final GoogleMapController controller =
                                //         await _controller.future;
                                //     setState(() {
                                //       _addressLine1Controller.text =
                                //           result.address;
                                //       _location = result.address;
                                //       _addressLine1Controller.text = '';
                                //       _addr1 = '';
                                //       _addressLine2Controller.text = '';
                                //       _addr2 = '';
                                //       _selectedLatitude =
                                //           result.latLng.latitude;
                                //       _selectedLongitude =
                                //           result.latLng.longitude;
                                //     });
                                //     controller.animateCamera(
                                //       CameraUpdate.newCameraPosition(
                                //         CameraPosition(
                                //           bearing: 0,
                                //           target: LatLng(
                                //             result.latLng.latitude,
                                //             result.latLng.longitude,
                                //           ),
                                //           zoom: 17.0,
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),
                                PrimaryButton(
                                  title: 'Saved Address',
                                  onPressed: () => _savedAddresses(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Set delivery location',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_location != null)
                              Text(
                                '$_location',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _addressLine1Controller,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                labelText: 'HOUSE/FLAT/BLOCK NO.',
                                alignLabelWithHint: true,
                                errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _addr1 = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
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
                            SizedBox(
                              height: 10,
                            ),
                            if (_pincodes != null)
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                ),
                                // child: Padding(
                                //   padding: EdgeInsets.only(left: 10, right: 10),
                                //   child: SearchableDropdown.single(
                                //     readOnly: !_isNewAddress,
                                //     value: !_isNewAddress
                                //         ? _selectPincode.pincode
                                //         : null,
                                //     keyboardType: TextInputType.number,
                                //     items: _pincodes,
                                //     hint: "Delivery pincode",
                                //     searchHint: "Select delivery pincode",
                                //     onChanged: (value) {
                                //       PincodeDto selectedPincode =
                                //           _pincodesDetails.firstWhere(
                                //               (element) =>
                                //                   element.pincode == value);
                                //       setState(() {
                                //         _pin = value;
                                //         _selectPincode = selectedPincode;
                                //       });
                                //       if ((!widget.isBasket || widget.isOnetimeBasket) &&
                                //           !_isDeliveryCheckboxEditable) {
                                //         displayToastMessage(
                                //           'Delivery charge of ₹${_selectPincode.deliveryCharges} will be applied',
                                //           color: Colors.orange,
                                //         );
                                //         setState(() {
                                //           _deliveryCharges =
                                //               _selectPincode.deliveryCharges;
                                //         });
                                //       }
                                //       _selectedSlot =
                                //           _selectPincode.slots[0].id;
                                //       _scrollController.animateTo(
                                //         _scrollController
                                //             .position.maxScrollExtent,
                                //         curve: Curves.easeOut,
                                //         duration:
                                //             const Duration(milliseconds: 500),
                                //       );
                                //     },
                                //     isExpanded: true,
                                //   ),
                                // ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (widget.isBasket! &&
                                !widget.isOnetimeBasket! &&
                                _selectPincode != null &&
                                _selectPincode.slots.length > 0)
                              // SelectDeliverySlot(
                              //     _selectPincode.slots, setSelectedSlot),
                            if (_selectPincode != null &&
                                (widget.isBasket! || widget.isOnetimeBasket!))
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: _isWithoutBasket,
                                        checkColor:
                                            Theme.of(context).accentColor,
                                        activeColor: Colors.green,
                                        onChanged: !_isDeliveryCheckboxEditable
                                            ? null
                                            : (val) {
                                                setState(() {
                                                  _isWithoutBasket = val!;
                                                });
                                                if (val!) {
                                                  displayToastMessage(
                                                    'Delivery charge of ₹${_selectPincode.deliveryCharges} will be applied',
                                                    color: Colors.orange,
                                                  );
                                                  setState(() {
                                                    _deliveryCharges =
                                                        _selectPincode
                                                            .deliveryCharges;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _deliveryCharges = 0;
                                                  });
                                                }
                                              },
                                      ),
                                      Text(
                                        'Deliver within ${_selectPincode.deliveryDays} days?',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      _isWithoutBasket ? 'Will be delivered within ${_selectPincode.deliveryDays} days.' : 'Will be delivered with next basket delivery.',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      ApplyCoupon(_applyCouponCode, _clearCouponCode, ctx),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      BillDetails(
                          widget.cartAmount!, _deliveryCharges, discountPrice),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              !validateCheckout()
                  ? SizedBox()
                  : CartFooter(
                      cartAmount: ((widget.isBasket! && !widget.isOnetimeBasket!) || !_isWithoutBasket)
                          ? widget.cartAmount! - discountPrice
                          : widget.cartAmount! +
                              _deliveryCharges -
                              discountPrice,
                      cart: widget.cart,
                      clearCart: widget.clearCart,
                      isBasket: widget.isBasket,
                      isOnetimeBasket: widget.isOnetimeBasket,
                      isWithBasket: !_isWithoutBasket,
                      addressDto: AddressDto(
                          _selectedAddressId,
                          _location,
                          _addr1,
                          _addr2,
                          _selectedLatitude,
                          _selectedLongitude,
                          _selectPincode),
                      slot: _selectedSlot,
                      isNewAddress: _isNewAddress,
                      refreshBasketDetails: widget.refreshBasketDetails,
                      basketId: widget.basketId,
                      couponCode: couponCode,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
