import 'package:flutter/material.dart';

import '../generated/assets.dart';

class Logo extends StatelessWidget {
  final double height;

  Logo(this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Image.asset(
        Assets.imagesLogoe,
        fit: BoxFit.cover,
      ),
    );
  }
}
