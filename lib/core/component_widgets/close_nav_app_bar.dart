// import 'package:brain_bench/core/styles/colors.dart'; // Nicht mehr hier benötigt
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class CloseNavAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CloseNavAppBar({
    super.key,
    required this.title,
    required this.onBack,
    this.actions,
    this.leadingIcon,
    this.leadingIconColor,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final IconData? leadingIcon;
  final Color? leadingIconColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final IconData iconData = leadingIcon ??
        (defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoIcons.clear
            : Icons.close);

    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          iconData,
          color: leadingIconColor,
        ),
        onPressed: onBack,
      ),
      actions: actions,
    );
  }
}
