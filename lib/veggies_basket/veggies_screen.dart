import 'package:flutter/material.dart';
import '../common_widget/cached_image.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../theme/full_screen_loader.dart';
import 'basket.dart';
import 'basket_dto.dart';


class VeggiesScreen extends StatelessWidget {
  Future<VeggiesDto> _fetchBaskets() async {
    dynamic response = await http.get(urls.basket, {});
    return VeggiesDto.fromJson(response['responseData']);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<VeggiesDto>(
        future: _fetchBaskets(),
        builder: (BuildContext context, AsyncSnapshot<VeggiesDto> snapshot) =>
            (snapshot.connectionState != ConnectionState.done)
                ? FullScreenLoader()
                : (!snapshot.hasData || snapshot.data!.basketDto.length == 0)
                    ? Center(
                        child: Text(
                          'No baskets to subscribe',
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedImage(
                                url: snapshot.data!.image,
                                height: (MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).padding.top -
                                        MediaQuery.of(context).padding.bottom) *
                                    0.25,
                                width: (MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).padding.left -
                                    MediaQuery.of(context).padding.right),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Exclusive Benefits to Members',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/basket_perks.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Sample Basket',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.oneTimeBasket.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemBuilder: (context, index) {
                                  return Basket(snapshot.data!.oneTimeBasket[index], true);
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Monthly Subscription Plans',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.basketDto.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemBuilder: (context, index) {
                                  return Basket(snapshot.data!.basketDto[index], false);
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  'How It Works',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...snapshot.data!.howItWorks.map((e) {
                                return Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\u2022  ',
                                      ),
                                      Flexible(child: Text(e)),
                                    ],
                                  ),
                                );
                              }).toList(),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
