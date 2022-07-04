import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final Color color;
  const FullScreenLoader({this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
