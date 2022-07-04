import 'package:flutter/material.dart';

import '../product/categories.dart';


class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Categories(),
      ),
    );
  }
}
