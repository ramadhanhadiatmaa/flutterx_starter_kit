import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global configuration for TextKit widgets.
///
/// ### Supported Fonts
/// The configuration supports any Google Font family name. Common examples:
/// - `poppins` (default)
/// - `fredoka`
/// - `roboto`
/// - `montserrat`
/// - `opensans`
/// - `lato`
/// - `nunito`
/// - `raleway`
/// - `inter`
class TextKitConfig {
  /// Private constructor to prevent instantiation.
  TextKitConfig._();

  /// Default font family being used by all TextKit widgets 'poppins'.
  static String _fontFamily = 'poppins';

  /// The [fontFamily] parameter should match a Google Fonts family name.
  /// Font names are automatically sanitized (lowercased, special chars removed).
  static void setFont(String fontFamily) {
    _fontFamily = fontFamily.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  /// Gets the current font family.
  static String get fontFamily => _fontFamily;

  /// Creates a [TextStyle] with the configured font family.
  static TextStyle getTextStyle({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    // Map font family to GoogleFonts method
    switch (_fontFamily) {
      case 'fredoka':
        return GoogleFonts.fredoka(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
        );
      case 'roboto':
        return GoogleFonts.roboto(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
        );
      case 'montserrat':
        return GoogleFonts.montserrat(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
        );
      case 'opensans':
        return GoogleFonts.openSans(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
        );
      case 'lato':
        return GoogleFonts.lato(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
        );
      case 'nunito':
        return GoogleFonts.nunito(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
        );
      case 'raleway':
        return GoogleFonts.raleway(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
        );
      case 'inter':
        return GoogleFonts.inter(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
        );
      case 'poppins':
      default:
        return GoogleFonts.poppins(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          height: height,
          letterSpacing: letterSpacing,
        );
    }
  }
}

/// A customizable text widget with pre-configured typography styles.
class TextKit extends StatelessWidget {
  /// Creates a TextKit widget.
  ///
  /// All parameters except [title] are required when using the default
  const TextKit({
    super.key,
    required this.title,
    required this.size,
    required this.color,
    required this.weight,
    this.align,
    this.height,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
  });

  /// The text content to display.
  final String title;

  /// The size of the text in logical pixels.
  final double size;

  /// The color to use when painting the text.
  final Color color;

  /// The typeface thickness
  final FontWeight weight;

  /// How the text should be aligned horizontally.
  final TextAlign? align;

  /// The height multiplier for line spacing (e.g., 1.5 for 150% line height).
  final double? height;

  /// Additional spacing between characters in logical pixels.
  final double? letterSpacing;

  /// Maximum number of lines to display.
  final int? maxLines;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: TextKitConfig.getTextStyle(
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
      ),
    );
  }

  /// Creates a Display Large text style (57sp, Light).
  factory TextKit.displayLarge(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 57,
      color: color ?? Colors.black,
      weight: FontWeight.w300,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Display Medium text style (45sp, Regular).
  factory TextKit.displayMedium(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 45,
      color: color ?? Colors.black,
      weight: FontWeight.w400,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Display Small text style (36sp, Regular).
  factory TextKit.displaySmall(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 36,
      color: color ?? Colors.black,
      weight: FontWeight.w400,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Headline Large text style (32sp, SemiBold).
  factory TextKit.headlineLarge(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 32,
      color: color ?? Colors.black,
      weight: FontWeight.w600,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Headline Medium text style (28sp, SemiBold).
  factory TextKit.headlineMedium(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 28,
      color: color ?? Colors.black,
      weight: FontWeight.w600,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Headline Small text style (24sp, SemiBold).
  factory TextKit.headlineSmall(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 24,
      color: color ?? Colors.black,
      weight: FontWeight.w600,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Title Large text style (22sp, SemiBold).
  factory TextKit.titleLarge(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 22,
      color: color ?? Colors.black,
      weight: FontWeight.w600,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Title Medium text style (16sp, Medium).
  factory TextKit.titleMedium(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 16,
      color: color ?? Colors.black,
      weight: FontWeight.w500,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Title Small text style (14sp, Medium).
  factory TextKit.titleSmall(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 14,
      color: color ?? Colors.black,
      weight: FontWeight.w500,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Body Large text style (16sp, Regular).
  factory TextKit.bodyLarge(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 16,
      color: color ?? Colors.black87,
      weight: FontWeight.w400,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      height: height ?? 1.5,
    );
  }

  /// Creates a Body Medium text style (14sp, Regular).
  factory TextKit.bodyMedium(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 14,
      color: color ?? Colors.black87,
      weight: FontWeight.w400,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      height: height ?? 1.5,
    );
  }

  /// Creates a Body Small text style (12sp, Regular).
  factory TextKit.bodySmall(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 12,
      color: color ?? Colors.black54,
      weight: FontWeight.w400,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
      height: height ?? 1.5,
    );
  }

  /// Creates a Label Large text style (14sp, Medium).
  factory TextKit.labelLarge(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 14,
      color: color ?? Colors.white,
      weight: FontWeight.w500,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Label Medium text style (12sp, Medium).
  factory TextKit.labelMedium(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 12,
      color: color ?? Colors.white,
      weight: FontWeight.w500,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Creates a Label Small text style (11sp, Regular).
  factory TextKit.labelSmall(
    String title, {
    Key? key,
    Color? color,
    TextAlign? align,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextKit(
      key: key,
      title: title,
      size: 11,
      color: color ?? Colors.black54,
      weight: FontWeight.w400,
      align: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
