import 'package:brain_bench/core/shared_widgets/buttons/profile_button_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

/// A custom app bar with a back navigation button and a title.
class BackNavAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackNavAppBar({
    super.key,
    required this.title,
    required this.onBack,
    this.backgroundColor,
    this.elevation,
  });

  /// The title to display in the app bar.
  final String title;

  /// A callback function to be called when the back navigation button is pressed.
  final VoidCallback? onBack;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The elevation of the app bar.
  final double? elevation;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          defaultTargetPlatform == TargetPlatform.iOS
              ? CupertinoIcons.chevron_back
              : Icons.arrow_back,
        ),
        onPressed: onBack,
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      actions: const [ProfileButtonView(), SizedBox(width: 8)],
    );
  }
}
