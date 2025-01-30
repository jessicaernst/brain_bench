/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAppIconsGen {
  const $AssetsAppIconsGen();

  /// File path: assets/app_icons/evo1.png
  AssetGenImage get evo1 => const AssetGenImage('assets/app_icons/evo1.png');

  /// File path: assets/app_icons/evo2.png
  AssetGenImage get evo2 => const AssetGenImage('assets/app_icons/evo2.png');

  /// File path: assets/app_icons/evo3.png
  AssetGenImage get evo3 => const AssetGenImage('assets/app_icons/evo3.png');

  /// File path: assets/app_icons/evo4.png
  AssetGenImage get evo4 => const AssetGenImage('assets/app_icons/evo4.png');

  /// List of all assets
  List<AssetGenImage> get values => [evo1, evo2, evo3, evo4];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/DashLogo.png
  AssetGenImage get dashLogo =>
      const AssetGenImage('assets/images/DashLogo.png');

  /// File path: assets/images/DashLogoSmaller.png
  AssetGenImage get dashLogoSmaller =>
      const AssetGenImage('assets/images/DashLogoSmaller.png');

  /// List of all assets
  List<AssetGenImage> get values => [dashLogo, dashLogoSmaller];
}

class Assets {
  Assets._();

  static const $AssetsAppIconsGen appIcons = $AssetsAppIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
