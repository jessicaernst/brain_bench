import 'package:brain_bench/core/component_widgets/glass_card_view.dart';
import 'package:brain_bench/core/component_widgets/light_dark_switch_btn.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

final Logger _logger = Logger('ProfileEditView');

class ProfileEditView extends StatelessWidget {
  const ProfileEditView({
    super.key,
    required this.displayNameController,
    required this.emailController,
    required this.localizations,
    required this.textTheme,
    required this.theme,
    required this.userImageUrl,
    required this.onPressed,
  });

  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final AppLocalizations localizations;
  final TextTheme textTheme;
  final ThemeData theme;
  final String? userImageUrl;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCardView(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              // Use Stack to overlay edit button on avatar
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.primaryColor.withAlpha((0.4 * 255).toInt()),
                      width: 3.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent,
                    // Same image logic as in ProfileView
                    backgroundImage: userImageUrl != null
                        ? NetworkImage(userImageUrl!) as ImageProvider
                        : Assets.images.evolution4.provider(),
                    onBackgroundImageError: (exception, stackTrace) {
                      _logger.warning('Error loading user image: $exception');
                    },
                  ),
                ),
                // Button to change picture (Placeholder)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.surface
                        .withAlpha((0.87 * 255).toInt()),
                    child: IconButton(
                      icon: Icon(
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? CupertinoIcons.camera_fill
                            : Icons.camera_alt,
                        color: theme.primaryColor,
                      ),
                      iconSize: 24,
                      tooltip: localizations.profileChangePictureTooltip,
                      onPressed: () {
                        // TODO: Implement image picker logic
                        _logger.info('Change profile picture tapped');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          // Display Name TextField
          TextField(
            controller: displayNameController,
            style: textTheme.headlineSmall,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: localizations.profileDisplayNameLabel,
              // Remove border for a cleaner look until focused
              border: InputBorder.none,
              // Center the label text when focused/floating
              floatingLabelAlignment: FloatingLabelAlignment.center,
              // Optional: Add hint text if needed
              // hintText: localizations.profileDisplayNameHint,
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          // Email TextField (Read-Only)
          TextField(
            controller: emailController,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: localizations.profileEmailLabel, // Add localization
              border: InputBorder.none,
              floatingLabelAlignment: FloatingLabelAlignment.center,
              // Optional: Add an icon to indicate it's locked/verified
              // suffixIcon: Icon(Icons.lock, size: 16, color: theme.disabledColor),
            ),
          ),
          const SizedBox(height: 48),
          LightDarkSwitchBtn(
            title: localizations.profileEditBtnLbl,
            isActive: true,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
