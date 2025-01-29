import 'package:flutter/material.dart';

/// GradientDesignBtn
///
/// This approach is chosen because ElevatedButtons do not support gradients,
/// and more flexibility is needed here.
///
/// A customizable button with:
/// - **Gradient Background**: A gradient covering the entire button.
/// - **Stroke**: Optional border with its own gradient.
/// - **Shadows**: Customizable shadows rendered beneath the button.
/// - **InkWell Effect**: Ripple effect for visual feedback on interaction.
/// - **Active & Inactive State**: Allows toggling between an active and an inactive state using gradients.
///
/// Structure:
/// The button is organized using a Stack and consists of:
/// 1. **Shadow Layer (optional)**:
///    - Renders the button's shadow.
///    - Can be adjusted or disabled using the `shadows` property.
/// 2. **Button Content**:
///    - Contains the gradient (active or inactive), stroke, and title.
///    - The Material widget ensures the InkWell ripple effect.
/// 3. **Stroke Layer**:
///    - Optional border with a gradient.
///    - A ShaderMask precisely applies the gradient to the border.
/// 4. **Title Layer**:
///    - The button title is a widget (e.g., Text) that can be freely customized.
///    - It is centered and scaled to prevent text wrapping.
///
/// Customization Options:
/// - `width` and `height`: Manual control of button size (optional).
/// - `contentGradient`: Gradient for the button background (active state).
/// - `inactiveGradient`: Optional gradient for the inactive state.
/// - `isActive`: Boolean to toggle between active and inactive states.
/// - `strokeGradient`: Gradient for the button border.
/// - `strokeWidth`: Thickness of the border.
/// - `shadows`: Button shadows.
/// - `padding`: Internal spacing between the button edges and the title.
/// - `title`: Widget for the button title (e.g., stylized text).
///
/// Usage:
/// GradientDesignBtn(
///   title: Text(
///     "Order Now",
///     style: TextStyle(
///       fontSize: 16,
///       fontWeight: FontWeight.bold,
///       color: Colors.white,
///     ),
///   ),
///   onPressed: () {
///     print("Button pressed!");
///   },
///   width: 200,
///   height: 50,
///   contentGradient: LinearGradient(
///     colors: [Colors.blue, Colors.purple],
///   ),
///   inactiveGradient: LinearGradient(
///     colors: [Colors.grey, Colors.black12],
///   ),
///   isActive: true, // Switch between active and inactive state
///   strokeGradient: LinearGradient(
///     colors: [Colors.white, Colors.transparent],
///   ),
///   strokeWidth: 2.0,
///   shadows: [
///     BoxShadow(
///       color: Colors.black.withOpacity(0.2),
///       blurRadius: 10,
///       offset: Offset(0, 4),
///     ),
///   ],
/// );
///
/// Advantages:
/// - **Flexibility**: All components (Shadow, Stroke, Title) can be customized individually.
/// - **Active/Inactive State Management**: Allows toggling between states dynamically.
/// - **Responsive Design**: The button adapts dynamically to content when no fixed width is set.
/// - **Modular Concept**: Can be easily extended for various requirements.

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
  final bool isActive; // Flag to determine the button state (active/inactive)

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
          borderRadius: BorderRadius.circular(10),
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
          borderRadius: BorderRadius.circular(10),
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
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: currentGradient, // Uses the correct gradient based on state
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
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
                  child: title, // Button title
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
            borderRadius: BorderRadius.circular(10),
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
            borderRadius: BorderRadius.circular(10),
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

        return Stack(
          alignment: Alignment.center,
          children: [
            if (_buildShadowLayer(dynamicWidth, dynamicHeight) != null)
              _buildShadowLayer(dynamicWidth, dynamicHeight)!, // Shadow layer
            _buildButtonContent(
                context, dynamicWidth, dynamicHeight), // Main content
          ],
        );
      },
    );
  }
}
