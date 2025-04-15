import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class CloseNavAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CloseNavAppBar({
    super.key,
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: Icon(
          defaultTargetPlatform == TargetPlatform.iOS
              ? CupertinoIcons.clear
              : Icons.close,
        ),
        onPressed: onBack,
      ),
    );
  }
}
