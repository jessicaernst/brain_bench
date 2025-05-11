import 'package:flutter/material.dart';

class SocialImageButton extends StatelessWidget {
  const SocialImageButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
    this.size = 48,
  });

  final String imagePath;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        clipBehavior: Clip.hardEdge,
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}
