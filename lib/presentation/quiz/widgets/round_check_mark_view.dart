import 'package:flutter/material.dart';

class RoundCheckMarkView extends StatelessWidget {
  const RoundCheckMarkView({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
      ),
      child:
          isSelected
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
    );
  }
}
