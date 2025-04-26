import 'package:brain_bench/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class ErrorContentView extends StatelessWidget {
  const ErrorContentView({
    super.key,
    required this.theme,
    required this.isThemeBusy,
    required this.localizations,
    required this.handleRefresh,
  });

  final ThemeData theme;
  final bool isThemeBusy;
  final AppLocalizations localizations;
  final VoidCallback handleRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
        const SizedBox(width: 8),
        TextButton(
          onPressed: isThemeBusy
              ? null
              : handleRefresh, // Disable if refresh is in progress
          child: Text(localizations.settingsRefreshButtonLabel),
        ),
      ],
    );
  }
}
