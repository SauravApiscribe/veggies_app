import 'package:flutter/material.dart';
import 'package:veggies_app/order/previous_order_card.dart';
import 'package:veggies_app/order/previous_order_dto.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../theme/full_screen_loader.dart';


class PreviousOrders extends StatelessWidget {
  static const routeName = '/order-history';

  Future<List<PreviousOrder>> _fetchPreviousOrders() async {
    dynamic response = await http.get(urls.order + '?status=FAIL,SUCCESS', {});
    List<PreviousOrder> previousOrders =
        (response['responseData']['orders'] as List<dynamic>)
            .map((e) => PreviousOrder.fromJson(e))
            .toList();
    return previousOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        leading: BackButton(),
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'Previous Orders',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Builder(
        builder: (ctx) => SafeArea(
          child: FutureBuilder<List<PreviousOrder>>(
            future: _fetchPreviousOrders(),
            builder: (BuildContext context,
                    AsyncSnapshot<List<PreviousOrder>> snapshot) =>
                !snapshot.hasData
                    ? FullScreenLoader()
                    : (snapshot.data!.length > 0)
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: snapshot.data!
                                    .map((e) => PreviousOrderCard(e))
                                    .toList(),
                              ),
                            ),
                          )
                        : Center(
                            child: Text('No previous orders. Order now!',
                                style: TextStyle(fontSize: 18)),
                          ),
          ),
        ),
      ),
    );
  }
}
