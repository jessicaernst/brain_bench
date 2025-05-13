import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/shared_widgets/appbars/close_nav_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ProfilePageAppBar({
    super.key,
    required this.isEditing,
    required this.profileUpdateIsLoading,
    required this.localizations,
    required this.iconColor,
    required this.isSaveEnabled,
    required this.onSaveChanges,
    required this.onToggleEditMode,
    required this.onBackAction,
  });

  final bool isEditing;
  final bool profileUpdateIsLoading;
  final AppLocalizations localizations;
  final Color iconColor;
  final bool isSaveEnabled;
  final VoidCallback onSaveChanges;
  final VoidCallback onToggleEditMode;
  final VoidCallback onBackAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData? leadingAppBarIcon;
    if (isEditing) {
      leadingAppBarIcon =
          defaultTargetPlatform == TargetPlatform.iOS
              ? CupertinoIcons.chevron_back
              : Icons.arrow_back;
    }

    return CloseNavAppBar(
      title:
          isEditing
              ? localizations.profileEditAppBarTitle
              : localizations.profileAppBarTitle,
      onBack: onBackAction,
      leadingIconColor: iconColor,
      leadingIcon: leadingAppBarIcon,
      actions: [
        IconButton(
          icon:
              profileUpdateIsLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CupertinoActivityIndicator(radius: 10),
                  )
                  : (isEditing
                      ? (defaultTargetPlatform == TargetPlatform.iOS
                          ? Icon(CupertinoIcons.floppy_disk, color: iconColor)
                          : Icon(Icons.save, color: iconColor))
                      : (defaultTargetPlatform == TargetPlatform.iOS
                          ? Icon(CupertinoIcons.pencil, color: iconColor)
                          : Icon(Icons.edit, color: iconColor))),
          onPressed:
              isEditing
                  ? (isSaveEnabled ? onSaveChanges : null)
                  : onToggleEditMode,
          tooltip:
              isEditing
                  ? localizations.profileSaveTooltip
                  : localizations.profileEditTooltip,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
