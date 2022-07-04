import 'package:flutter/material.dart';
import 'package:veggies_app/product/product.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../theme/full_screen_loader.dart';
import 'favorite_products_dto.dart';


class FavoriteProducts extends StatelessWidget {
  static const routeName = '/favorites';

  Future<List<FavoriteProductDto>> _fetchUserFavorites() async {
    dynamic response = await http.get(urls.favorite, {});
    List<FavoriteProductDto> favoriteProducts =
        (response['responseData']['favorites'] as List<dynamic>)
            .map((e) => FavoriteProductDto.fromJson(e))
            .toList();
    return favoriteProducts;
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
          'Favorite Products',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _fetchUserFavorites(),
        builder: (BuildContext context,
                AsyncSnapshot<List<FavoriteProductDto>> snapshot) =>
            (snapshot.connectionState != ConnectionState.done)
                ? FullScreenLoader()
                : (!snapshot.hasData || snapshot.data!.length == 0)
                    ? Center(
                        child: Text(
                          'Start adding your favorite products.',
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return Product(snapshot.data![index].product);
                            },
                          ),
                        ),
                      ),
      ),
    );
  }
}
