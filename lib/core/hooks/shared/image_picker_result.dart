import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Represents the result of an image picker operation.
class ImagePickerResult {
  final ValueNotifier<XFile?> selectedImage;
  final Future<void> Function([BuildContext? context]) pickImage;

  /// Creates a new instance of [ImagePickerResult].
  ///
  /// The [selectedImage] parameter is a [ValueNotifier] that holds the currently selected image.
  /// The [pickImage] parameter is a function that allows picking an image.
  ImagePickerResult({required this.selectedImage, required this.pickImage});
}
