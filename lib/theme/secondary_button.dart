import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({Key? key, required this.title, required this.onPressed, required this.color})
      : super(key: key);
  final String title;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: color ?? Theme.of(context).accentColor,
          fontSize: 18,
        ),
      ),
    );
  }
}
