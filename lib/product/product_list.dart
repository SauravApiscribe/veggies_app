import 'package:flutter/material.dart';
import 'package:veggies_app/product/product.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../theme/full_screen_loader.dart';
import 'dto/category_dto.dart';
import 'dto/product_dto.dart';


class ProductList extends StatefulWidget {
  static const routeName = '/products';

  final String category;

  ProductList({this.category = ''});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Future<List<ProductDto>> _fetchProducts(int categoryId) async {
    dynamic response = await http.get(urls.products + '?type=NORMAL&category=$categoryId', {});
    List<ProductDto> products =
        (response['responseData']['products'] as List<dynamic>).map((value) {
      return ProductDto.fromJson(value);
    }).toList();
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as CategoryDto;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        leading: BackButton(),
        title: Text(
          '${category.name}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _fetchProducts(category.id),
          builder: (BuildContext context,
                  AsyncSnapshot<List<ProductDto>> snapshot) =>
              (snapshot.connectionState != ConnectionState.done)
                  ? FullScreenLoader()
                  : (!snapshot.hasData || snapshot.data!.length == 0)
                      ? Center(
                          child: Text(
                            'No products in this category',
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
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) {
                                return Product(snapshot.data![index]);
                              },
                            ),
                          ),
                        ),
        ),
      ),
    );
  }
}
