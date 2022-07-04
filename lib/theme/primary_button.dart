import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.title, required this.onPressed}) : super(key: key);
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 18,
        ),
      ),

    );
  }
}
