import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({Key? key, required this.title, required this.onPressed}) : super(key: key);
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
