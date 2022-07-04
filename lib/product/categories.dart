import 'package:flutter/material.dart';
import 'package:veggies_app/product/product_list.dart';

import '../common_widget/cached_image.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import 'dto/category_dto.dart';


class Categories extends StatelessWidget {
  Future<List<CategoryDto>> _fetchCategories() async {
    dynamic response = await http.get(urls.categories, {});
    List<CategoryDto> categories =
        (response['responseData']['categories'] as List<dynamic>).map((value) {
      return CategoryDto.fromJson(value);
    }).toList();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchCategories(),
      builder: (BuildContext context,
              AsyncSnapshot<List<CategoryDto>> snapshot) =>
          !snapshot.hasData
              ? SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explore By Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ProductList.routeName,
                                      arguments: snapshot.data![index]);
                                },
                                child: CachedImage(
                                  url: snapshot.data![index].image,

                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
                                child: Text(
                                  snapshot.data![index].name,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
    );
  }
}
