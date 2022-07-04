import 'package:flutter/material.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../theme/dialog.dart';
import '../theme/full_screen_loader.dart';
import 'add_address.dart';
import 'address_dto.dart';
import 'address_item.dart';

class ManageAddress extends StatefulWidget {
  static const routeName = '/my-address';

  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  late List<AddressDto> _userAddresses;

  Future<void> _fetchUserAddress() async {
    dynamic response = await http.get(urls.address, {});
    //if ((response['responseData']['addresses'] as List<dynamic>).isNotEmpty) {
    List<AddressDto> userAddresses =
        (response['responseData']['addresses'] as List<dynamic>)
            .map((e) => AddressDto.fromJson(e))
            .toList();
    setState(() {
      _userAddresses = userAddresses;
    });
    //}
  }

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
  }

  void _deleteAddress(BuildContext ctx, int addressId) {
    showLoader(ctx, title: 'Deleting address');
    http.delete(
      urls.address + '$addressId/',
      {},
    ).then((value) {
      hideLoader(ctx);
    }).catchError((error) {
      hideLoader(ctx);
      displaySnackBarMessage(ctx, 'Something went wrong');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        leading: BackButton(),
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'My Address',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => AddAddress(_fetchUserAddress))),
        child: Icon(
          Icons.add_location_alt,
          color: Colors.green,
        ),
      ),
      body: SafeArea(
        child: _userAddresses == null
            ? FullScreenLoader()
            : _userAddresses.length == 0
                ? Center(
                    child: Text(
                      'Start adding your address',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ..._userAddresses
                            .map((e) => AddressItem(e, _deleteAddress))
                            .toList(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
