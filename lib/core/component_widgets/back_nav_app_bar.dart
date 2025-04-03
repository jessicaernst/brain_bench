import 'package:brain_bench/presentation/home/widgets/profile_button_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class BackNavAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackNavAppBar(
      {super.key,
      required this.title,
      required this.onBack,
      required this.userImageUrl,
      required this.profilePressed,
      required this.settingsPressed,
      required this.logoutPressed});

  final String title;
  final VoidCallback? onBack;
  final String? userImageUrl;
  final VoidCallback profilePressed;
  final VoidCallback settingsPressed;
  final VoidCallback logoutPressed;

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
      actions: [
        ProfileButtonView(
          userImageUrl: userImageUrl,
          profilePressed: profilePressed,
          settingsPressed: settingsPressed,
        )
      ],
    );
  }
}
