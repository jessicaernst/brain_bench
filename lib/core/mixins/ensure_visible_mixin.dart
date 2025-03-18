import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// A mixin that provides a method to ensure that a widget is visible within a scrollable view.
mixin EnsureVisibleMixin<T extends StatefulWidget> on State<T> {
  final Logger logger = Logger('EnsureVisibleMixin');

  /// The GlobalKey associated with the widget that needs to be made visible.
  GlobalKey get cardKey;

  /// Ensures that the widget associated with [cardKey] is visible within a scrollable view.
  void ensureCardIsVisible({String? cardName}) {
    logger.fine('_ensureCardIsVisible called for card: $cardName');
    Future.delayed(const Duration(milliseconds: 300), () {
      final RenderObject? renderObject =
          cardKey.currentContext?.findRenderObject();
      if (renderObject != null && renderObject.attached) {
        logger.info('Scrolling to make card visible: $cardName');
        Scrollable.ensureVisible(
          cardKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        logger.warning('RenderObject not found or not attached');
      }
    });
  }
}
