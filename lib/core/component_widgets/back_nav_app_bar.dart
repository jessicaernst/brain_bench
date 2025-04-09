import 'package:brain_bench/presentation/home/widgets/profile_button_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class BackNavAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackNavAppBar({
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
              ? CupertinoIcons.chevron_back
              : Icons.arrow_back,
        ),
        onPressed: onBack,
      ),
      actions: const [ProfileButtonView()],
    );
  }
}
