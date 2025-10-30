import 'package:flutter/material.dart';
import 'package:flutterx_starter_kit/flutterx_starter_kit.dart';

/// A single-color elevated button widget with configurable size, radius,
class ButtonKit extends StatelessWidget {
  /// Creates a ButtonKit.
  /// All of the parameters marked `required` must be provided.
  /// - [text]: The button label text.
  /// - [textColor]: Color for the label text.
  /// - [bgColor]: Background color of the button.
  /// - [press]: Callback executed when the button is pressed.
  /// - [radius]: Border radius of the button (defaults to 10.0).
  /// - [textSize]: Font size for the label (defaults to 14.0).
  /// - [width]: Width of the button (defaults to `double.infinity`).
  /// - [height]: Height of the button (defaults to 25.0).
  /// - [weight]: FontWeight for the label (defaults to `FontWeight.w500`).
  /// - [elevation]: Elevation for the ElevatedButton (defaults to 0.0).
  const ButtonKit({
    super.key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.press,
    this.radius,
    this.textSize,
    this.width,
    this.height,
    this.weight,
    this.elevation,
  });

  /// The button label text.
  final String text;

  /// Color used for the label text.
  final Color textColor;

  /// Background color of the button.
  final Color bgColor;

  /// Elevation value for the [ElevatedButton]. If `null`, defaults to `0.0`.
  final double? elevation;

  /// Font size for the label. If `null`, defaults to `14.0`.
  final double? textSize;

  /// Width of the button. If `null`, defaults to `double.infinity`.
  final double? width;

  /// Height of the button. If `null`, defaults to `25.0`.
  final double? height;

  /// Corner radius of the button. If `null`, defaults to `10.0`.
  final double? radius;

  /// Font weight for the label text. If `null`, defaults to `FontWeight.w500`.
  final FontWeight? weight;

  /// Callback executed when the button is pressed.
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 0.0,
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 5.0),
        ),
      ),
      onPressed: press,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 25.0,
        child: Center(
          child: TextKit(
            title: text,
            size: textSize ?? 14.0,
            color: textColor,
            weight: weight ?? FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// A gradient button widget that renders a gradient background and places
/// an [ElevatedButton] on top with transparent background so splash and
/// semantics are preserved.
///
/// Useful when you want a tappable area with a gradient fill.
class ButtonKitGradient extends StatelessWidget {
  /// Creates a [ButtonKitGradient].
  /// Required parameters:
  /// - [text]: The button label text.
  /// - [textColor]: Color for the label text.
  /// - [bgColor1], [bgColor2]: Gradient colors (start and end).
  /// - [press]: Callback when button is pressed.
  /// - [radius]: Border radius of the gradient container (defaults to 10.0).
  /// - [textSize]: Font size for the label (defaults to 12.0).
  /// - [width]: Width of the button (defaults to `double.infinity`).
  /// - [height]: Height of the button (defaults to 25.0).
  /// - [weight]: FontWeight for the label (defaults to `FontWeight.w500`).
  /// - [elevation]: Elevation for the inner [ElevatedButton] (defaults to 0.0).
  /// - [align]: Text alignment for the [TextKit] label (defaults to `TextAlign.center`).
  const ButtonKitGradient({
    super.key,
    required this.text,
    required this.textColor,
    required this.bgColor1,
    required this.bgColor2,
    required this.press,
    this.radius,
    this.textSize,
    this.width,
    this.height,
    this.weight,
    this.elevation,
    this.align,
  });

  /// The button label text.
  final String text;

  /// Color used for the label text.
  final Color textColor;

  /// Gradient start color.
  final Color bgColor1;

  /// Gradient end color.
  final Color bgColor2;

  /// Font size for the label. If `null`, defaults to `12.0`.
  final double? textSize;

  /// Corner radius of the gradient container. Defaults to `10.0`.
  final double? radius;

  /// Width of the button. If `null`, defaults to `double.infinity`.
  final double? width;

  /// Height of the button. If `null`, defaults to `25.0`.
  final double? height;

  /// Elevation for the inner [ElevatedButton]. If `null`, defaults to `0.0`.
  final double? elevation;

  /// Font weight for the label text.
  final FontWeight? weight;

  /// Callback executed when the button is pressed.
  final VoidCallback press;

  /// Text alignment for the label inside the button.
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor1, bgColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius ?? 5.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation ?? 0.0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 5.0),
          ),
        ),
        onPressed: press,
        child: SizedBox(
          width: width ?? double.infinity,
          height: height ?? 25.0,
          child: Center(
            child: TextKit(
              title: text,
              size: textSize ?? 12.0,
              color: textColor,
              weight: weight ?? FontWeight.w500,
              align: align ?? TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
