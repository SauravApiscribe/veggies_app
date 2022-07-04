import 'package:flutter/material.dart';

import '../cart/add_to_cart_button.dart';
import '../common_widget/cached_image.dart';
import '../helpers/shared_preferences_helper.dart';
import '../my_account/user_dto.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;

import '../theme/dialog.dart';
import 'dto/product_dto.dart';


class ProductDetails extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
  }

  void _toggleFavourite(BuildContext ctx, productId) {
    showLoader(ctx, title: '');
    if(isFavourite) {
      http.delete(urls.favorite + '$productId/', {}).then((value) {
        hideLoader(ctx);
        setState(() {
          isFavourite = false;
        });
      }).catchError((error) {
        hideLoader(ctx);
        displayToastMessage('Remove from favorite failed', color: Colors.red);
      });
    } else {
      http.post(urls.favorite, {}, {
        'product': productId,
      }).then((value) {
        hideLoader(ctx);
        setState(() {
          isFavourite = true;
        });
      }).catchError((error) {
        hideLoader(ctx);
        displayToastMessage('Add to favorite failed', color: Colors.red);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productDto = ModalRoute.of(context)!.settings.arguments as ProductDto;
    setState(() {
      isFavourite = productDto.isFavorite;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        leading: BackButton(),
        title: Text(
          '${productDto.name}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Builder(
        builder: (ctx) => SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  CachedImage(
                    url: productDto.image,
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                        0.35,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${productDto.name}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            FutureBuilder(
                                future: SharedPreferencesHelper.getUserDetails(),
                                builder: (BuildContext ctx, AsyncSnapshot<UserDto> snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox();
                                  }
                                  if(snapshot.data!.token.isEmpty) {
                                    return SizedBox();
                                  }
                                  return IconButton(
                                    onPressed: () => _toggleFavourite(ctx, productDto.id),
                                    alignment: Alignment.centerRight,
                                    icon: isFavourite ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 20,
                                    ) : const Icon(
                                      Icons.favorite_border,
                                      size: 20,
                                    ),
                                  );
                                }
                            ),
                          ],
                        ),
                        Text(
                          '${productDto.quantities[0].quantity} ${productDto.quantities[0].unit}',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (productDto.mrp == productDto.price)
                                    ? SizedBox()
                                    : Row(
                                        children: [
                                          Text(
                                            '₹${productDto.mrp}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                Text(
                                  '₹${productDto.price}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            productDto.inStock
                                ? AddToCartButton(productDto)
                                : Text(
                                    'Out of Stock',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${productDto.description}',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Health Benefits',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: productDto.healthBenefits
                              .map((e) => Text('\u2022  $e'))
                              .toList(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Nutrition Details',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: productDto.nutritionBenefits
                              .map((e) => Text('\u2022  $e'))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
