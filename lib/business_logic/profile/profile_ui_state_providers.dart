import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_ui_state_providers.g.dart';

/// Holds a profile image that might be provisionally displayed
/// (e.g., from device contacts) if no Firebase photoUrl is available.
/// This is primarily managed by ProfilePage and can be read by other UI components
/// like ProfileButtonView for consistent display.
@riverpod
class ProvisionalProfileImage extends _$ProvisionalProfileImage {
  @override
  XFile? build() {
    // This provider will be null initially.
    // ProfilePage will update it when a contact image is fetched.
    // It should also be cleared if a Firebase image becomes available or on logout.
    return null;
  }

  void setImage(XFile? image) {
    state = image;
  }

  void clearImage() {
    state = null;
  }
}

/// Signals that a one-time snackbar for auto-saved contact image should be shown.
/// Set to true by `ensureUserExistsIfNeeded`, consumed and reset by a UI widget.
@riverpod
class ShowContactImageAutoSaveSnackbar
    extends _$ShowContactImageAutoSaveSnackbar {
  @override
  bool build() {
    return false;
  }

  void trigger() {
    state = true;
  }

  void reset() {
    state = false;
  }
}
