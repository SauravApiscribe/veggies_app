import 'package:flutter/material.dart';
import '../common_widget/cached_image.dart';
import '../helpers/shared_preferences_helper.dart';
import '../my_account/user_dto.dart';
import '../theme/full_screen_loader.dart';
import '/networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import 'delivery_card.dart';
import 'delivery_dto.dart';


class MyDeliveries extends StatefulWidget {
  static const routeName = '/my-deliveries';

  @override
  _MyDeliveriesState createState() => _MyDeliveriesState();
}

class _MyDeliveriesState extends State<MyDeliveries> {
  bool hasEmptyDeliveries = false;

  Future<DeliveriesDto> _fetchDeliveryData() async {
    dynamic response = await http.get(urls.delivery, {});
    if ((response['responseData']['deliveries'] as List<dynamic>).length == 0) {
      setState(() {
        hasEmptyDeliveries = true;
      });

    }
    DeliveriesDto deliveriesDto =
        DeliveriesDto.fromJson(response['responseData']);
    return deliveriesDto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        leading: BackButton(),
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'My Basket',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: hasEmptyDeliveries
          ? Center(
              child: Text(
                'No previous Deliveries. Subscribe now!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : FutureBuilder(
              future: SharedPreferencesHelper.getUserDetails(),
              builder: (BuildContext context,
                      AsyncSnapshot<UserDto> snapshot) =>
                  !snapshot.hasData
                      ? FullScreenLoader()
                      : FutureBuilder(
                          future: _fetchDeliveryData(),
                          builder: (BuildContext context,
                                  AsyncSnapshot<DeliveriesDto> snapshot) =>
                              !snapshot.hasData
                                  ? FullScreenLoader()
                                  : SafeArea(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  top: 15, bottom: 15),
                                              color: Colors.green.shade400,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CachedImage(
                                                    height: 50,
                                                    width: 50,
                                                    url:
                                                        '${snapshot.data!.basketDetails.image}',
                                                    shape: BoxShape.circle,
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    '${snapshot.data!.basketDetails.name.toUpperCase()}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ...snapshot.data!.deliveries
                                                .map((e) => DeliveryCard(
                                                    e,
                                                    snapshot
                                                        .data!.basketDetails))
                                                .toList()
                                          ],
                                        ),
                                      ),
                                    ),
                        ),
            ),
    );
  }
}
