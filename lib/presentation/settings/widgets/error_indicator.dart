import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ErrorIndicator');

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    super.key,
    required this.error,
    required this.stackTrace,
    required this.textColor,
  });

  final Object error;
  final StackTrace stackTrace;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    _logger.severe(
        'Error loading locale for selection view', error, stackTrace);
    return Icon(
      Icons.error_outline,
      color: textColor,
      size: 24,
    );
  }
}
