import 'package:brain_bench/business_logic/profile/profile_notifier.dart';
import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:brain_bench/core/styles/colors.dart';
import 'package:brain_bench/navigation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeleteAccountButton extends HookConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor:
            isDarkMode
                ? BrainBenchColors.flutterSky
                : BrainBenchColors.blueprintBlue,
      ),
      child: Text(localizations.confirmDeleteAccount),
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (dialogContext) => AlertDialog(
                title: Text(localizations.profileDeleteAccountTitle),
                content: Text(localizations.profileDeleteAccountContent),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(localizations.cancel),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();

                      final success =
                          await ref
                              .read(profileNotifierProvider.notifier)
                              .deleteUserAccount();

                      if (!context.mounted) return;

                      if (success) {
                        context.goNamed(AppRouteNames.login);
                      } else {
                        final error = ref.read(profileNotifierProvider).error;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              localizations.profileDeleteAccountError(
                                error?.toString() ?? 'Unknown error',
                              ),
                            ),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      }
                    },
                    child: Text(
                      localizations.confirmDeleteAccount,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ),
        );
      },
    );
  }
}
