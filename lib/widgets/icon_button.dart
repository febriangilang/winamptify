import 'package:flutter/material.dart';

class IconButtons extends StatelessWidget {
  const IconButtons(
      {Key? key,
        required this.width,
        required this.icon,
        required this.onPressed})
      : super(key: key);

  final double width;

  final IconData icon;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextButton(
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}
