import 'package:flutter/material.dart';
import 'package:veggies_app/product/product_details.dart';


import '../cart/add_to_cart_button.dart';
import '../common_widget/cached_image.dart';
import '../helpers/shared_preferences_helper.dart';
import '../my_account/user_dto.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../theme/dialog.dart';
import 'dto/product_dto.dart';


class Product extends StatefulWidget {
  final ProductDto productDto;

  Product(this.productDto);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFavourite = widget.productDto.isFavorite;
    });
  }

  void _toggleFavourite(BuildContext ctx) {
    showLoader(ctx, title: '');
    if(isFavourite) {
      http.delete(urls.favorite + '${widget.productDto.id}/', {}).then((value) {
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
        'product': widget.productDto.id,
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetails.routeName, arguments: widget.productDto);
      },
      child: Builder(
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: CachedImage(
                  url: widget.productDto.image,
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.productDto.name}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
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
                                onPressed: () => _toggleFavourite(ctx),
                                alignment: Alignment.centerRight,
                                icon: isFavourite ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 20,
                                ) : Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                      Text(
                        '${widget.productDto.quantities[0].quantity} ${widget.productDto.quantities[0].unit}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (widget.productDto.mrp == widget.productDto.price)
                                  ? SizedBox()
                                  : Text(
                                      '₹${widget.productDto.mrp}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                              Text(
                                '₹${widget.productDto.price}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          widget.productDto.inStock
                              ? AddToCartButton(widget.productDto)
                              : Text(
                                  'Out of Stock',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
