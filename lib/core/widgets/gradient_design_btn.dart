import 'dart:ui';

import 'package:flutter/material.dart';

/// GradientDesignBtn
///
/// This button provides flexibility and styling that standard Flutter buttons (e.g., ElevatedButton) cannot achieve.
///
/// A customizable button with:
/// - **Gradient Background**: A gradient applied to the entire button.
/// - **Stroke**: An optional border with a gradient.
/// - **Shadows**: Customizable shadows rendered beneath the button.
/// - **InkWell Effect**: Ripple effect for visual feedback on interaction.
/// - **Active & Inactive States**: Dynamic toggling between active and inactive styles using gradients.
/// - **Optional Blur Effect**: A background blur effect can be applied to enhance visuals.
///
/// Structure:
/// The button is organized using a Stack and consists of:
/// 1. **Shadow Layer (optional)**:
///    - Renders the shadow of the button.
///    - Can be customized or disabled using the `shadows` property.
/// 2. **Blur Layer (optional)**:
///    - Applies a blur effect behind the button if `enableBlur` is set to true.
///    - Uses the `blurSigma` property to control blur intensity.
///    - Adds a semi-transparent overlay for enhanced appearance.
/// 3. **Button Content**:
///    - Contains the gradient (active or inactive), stroke, and title.
///    - The Material widget ensures the InkWell ripple effect.
/// 4. **Stroke Layer (optional)**:
///    - Adds a gradient border around the button.
///    - Achieved using a ShaderMask for precise gradient application.
/// 5. **Title Layer**:
///    - The button title is a widget (e.g., Text) that can be freely customized.
///    - It is centered and scaled to prevent text wrapping.
///
/// Customization Options:
/// - `width` and `height`: Manual control of button size (optional).
/// - `activeGradient`: Gradient for the button background in the active state.
/// - `inactiveGradient`: Gradient for the button background in the inactive state.
/// - `isActive`: Boolean to toggle between active and inactive states.
/// - `strokeGradient`: Gradient for the button border.
/// - `strokeWidth`: Thickness of the button border.
/// - `shadows`: Shadow styling for the button.
/// - `overlayGradient`: Semi-transparent gradient overlay for additional visual effects.
/// - `padding`: Internal spacing between button edges and the title.
/// - `title`: Widget for the button title (e.g., styled Text).
/// - `enableBlur`: Enables or disables the blur effect (default: false).
/// - `blurSigma`: Controls the intensity of the blur effect (default: 10.0).
///
/// Usage:
/// GradientDesignBtn(
///   title: Text(
///     "Light Mode",
///     style: Theme.of(context).textTheme.labelLarge,
///   ),
///   onPressed: () {
///     print("Button pressed!");
///   },
///   activeGradient: BrainBenchGradients.dashGradient,
///   overlayGradient: LinearGradient(
///     colors: [
///       Colors.white.withOpacity(0.3),
///       Colors.transparent,
///     ],
///   ),
///   strokeGradient: BrainBenchGradients.btnStrokeGradient,
///   enableBlur: true, // Activates the blur effect
///   blurSigma: 10.0, // Controls blur intensity
///   height: 50,
///   width: 200,
///   borderRadius: 30,
/// );
///
/// Advantages:
/// - **Flexibility**: All components (shadow, stroke, title) can be customized individually.
/// - **Active/Inactive State Management**: Dynamic toggling between styles.
/// - **Optional Blur Effect**: Adds a visually appealing background blur.
/// - **Responsive Design**: Automatically adapts to content size when no fixed width is set.
/// - **Modular Concept**: Easy to extend for various requirements.

class GradientDesignBtn extends StatelessWidget {
  const GradientDesignBtn({
    super.key,
    required this.title,
    required this.activeGradient,
    required this.onPressed,
    this.inactiveGradient,
    this.isActive = true,
    this.width,
    this.height,
    this.padding,
    this.strokeGradient,
    this.strokeWidth,
    this.shadows,
    this.overlayGradient,
    this.borderRadius = 10,
    this.enableBlur = false,
    this.blurSigma = 10.0,
  });

  final Widget title;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Gradient activeGradient;
  final Gradient? inactiveGradient;
  final Gradient? strokeGradient;
  final Gradient? overlayGradient;
  final double? strokeWidth;
  final List<BoxShadow>? shadows;
  final bool isActive;
  final double? borderRadius;
  final bool enableBlur; // Enables or disables the blur effect
  final double blurSigma; // Controls the intensity of the blur effect

  // Calculates the dynamic width based on the title and padding.
  double _calculateWidth(BuildContext context, BoxConstraints constraints) {
    if (width != null) {
      return width!;
    }

    // Check if the title is a Text widget to calculate width based on text content
    if (title is Text && (title as Text).data != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: (title as Text).data,
          style: (title as Text).style ??
              Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final contentWidth = textPainter.size.width;
      final paddingWidth = (padding?.horizontal ?? 40);

      // Total width (text content + padding)
      return contentWidth + paddingWidth;
    }

    // Default width when a non-text widget is used
    return constraints.maxWidth * 0.5; // 50% of the available width
  }

  // Creates the shadow layer behind the button.
  Widget? _buildShadowLayer(double width, double height) {
    if (shadows?.isEmpty ?? true) {
      return null; // No shadows defined
    }

    return Positioned(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          boxShadow: shadows,
        ),
      ),
    );
  }

  // Creates the overlay gradient layer.
  Widget? _buildOverlayLayer(double width, double height) {
    if (overlayGradient == null) {
      return null; // No overlay defined
    }

    return Positioned.fill(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: overlayGradient,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
      ),
    );
  }

  // Applies a blur effect if enabled
  Widget _applyBlurEffect(Widget child, double width, double height) {
    if (!enableBlur) {
      return child; // Return the original widget if blur is disabled
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          color: Colors.white
              .withAlpha((0.3 * 255).toInt()), // Semi-transparent fill
          child: child,
        ),
      ),
    );
  }

  // The main content of the button with an "InkWell" for click interaction.
  Widget _buildButtonContent(
      BuildContext context, double width, double height) {
    // Selects the active or inactive gradient based on isActive state
    final currentGradient = isActive
        ? activeGradient
        : (inactiveGradient ??
            activeGradient); // Defaults to active gradient if inactiveGradient is not provided

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: currentGradient, // Uses the correct gradient based on state
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          splashColor: Colors.white.withAlpha((0.2 * 255).toInt()),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_buildOverlayLayer(width, height) != null)
                _buildOverlayLayer(width, height)!, // Optional overlay layer
              _buildStrokeLayer(width, height), // Stroke layer
              Padding(
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: FittedBox(
                  fit: BoxFit.scaleDown, // Prevents text wrapping
                  child: Opacity(
                    opacity: isActive ? 1.0 : 0.3,
                    child: title,
                  ), // Button title
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Draws the stroke (border) of the button using a ShaderMask if a gradient is provided.
  Widget _buildStrokeLayer(double width, double height) {
    if (strokeGradient == null) {
      // Fallback stroke when no gradient is defined
      return Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
              width: strokeWidth ?? 1.5,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
        ),
      );
    }

    return Positioned.fill(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return strokeGradient!.createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: strokeWidth ?? 1.5,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dynamicWidth = _calculateWidth(context, constraints);
        final dynamicHeight = height ?? 48.0;

        final buttonContent =
            _buildButtonContent(context, dynamicWidth, dynamicHeight);

        // Apply blur effect if enabled
        return Stack(
          alignment: Alignment.center,
          children: [
            if (_buildShadowLayer(dynamicWidth, dynamicHeight) != null)
              _buildShadowLayer(dynamicWidth, dynamicHeight)!,
            _applyBlurEffect(buttonContent, dynamicWidth, dynamicHeight),
          ],
        );
      },
    );
  }
}
