import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_refresh_provider.g.dart';

/// A simple ChangeNotifier that can be called to refresh GoRouter when needed.
class RouterRefreshNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

/// Riverpod provider for the RouterRefreshNotifier
@riverpod
RouterRefreshNotifier routerRefresh(Ref ref) {
  return RouterRefreshNotifier();
}
