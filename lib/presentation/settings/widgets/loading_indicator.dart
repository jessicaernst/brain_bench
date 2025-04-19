import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('LoadingIndicator');

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, required this.textColor});
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    _logger.fine('Language selection is loading...');
    return SizedBox(
      width: 24,
      height: 24,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
      ),
    );
  }
}
