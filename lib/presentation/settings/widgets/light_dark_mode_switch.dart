import 'package:brain_bench/core/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LightDarkModeSwitch extends StatelessWidget {
  const LightDarkModeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.iconColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final bool isPlatformIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Row(
      children: [
        Icon(isPlatformIos ? CupertinoIcons.sun_max_fill : Icons.sunny,
            color: iconColor),
        const SizedBox(width: 8),
        if (isPlatformIos)
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: BrainBenchColors.flutterSky,
            thumbColor: BrainBenchColors.cloudCanvas,
          )
        else
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: BrainBenchColors.flutterSky,
            thumbColor: WidgetStateProperty.all<Color>(
              BrainBenchColors.cloudCanvas,
            ),
          ),
        const SizedBox(width: 8),
        Icon(isPlatformIos ? CupertinoIcons.moon_stars_fill : Icons.dark_mode,
            color: iconColor),
      ],
    );
  }
}
