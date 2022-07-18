import 'package:flutter/material.dart';
import 'package:veggies_app/home/sliders_and_banners.dart';
import 'package:veggies_app/home/top_savers.dart';

import '../product/categories.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlidersAndBanners(),
            // TopSavers(),
            // Categories(),
          ],
        ),
      ),
    );
  }
}
