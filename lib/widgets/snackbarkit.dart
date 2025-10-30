import 'package:flutter/material.dart';

/// Position of the snackbar on screen.
enum SnackbarPosition {
  /// Show snackbar at the top of the screen
  top,

  /// Show snackbar at the bottom of the screen (default)
  bottom,
}

/// Global configuration for SnackbarKit widgets.
class SnackbarKitConfig {
  /// Private constructor to prevent instantiation.
  SnackbarKitConfig._();

  /// Default duration for snackbars (default: 3 seconds).
  static Duration defaultDuration = const Duration(seconds: 3);

  /// Default behavior for snackbars (default: floating).
  static SnackBarBehavior defaultBehavior = SnackBarBehavior.floating;

  /// Default margin for snackbars (default: 20px all sides).
  static EdgeInsets defaultMargin = const EdgeInsets.all(20);

  /// Whether to show close button on snackbars (default: false).
  static bool showCloseButton = false;

  /// Whether to show progress indicator on snackbars (default: true).
  static bool showProgressIndicator = true;

  /// Height of the progress indicator (default: 4.0).
  static double progressIndicatorHeight = 4.0;

  /// Default position for snackbars (default: top).
  static SnackbarPosition defaultPosition = SnackbarPosition.top;

  /// Configures global defaults for all SnackbarKit instances.
  static void configure({
    Duration? defaultDuration,
    SnackBarBehavior? defaultBehavior,
    EdgeInsets? defaultMargin,
    bool? showCloseButton,
    bool? showProgressIndicator,
    double? progressIndicatorHeight,
    SnackbarPosition? defaultPosition,
  }) {
    if (defaultDuration != null) {
      SnackbarKitConfig.defaultDuration = defaultDuration;
    }
    if (defaultBehavior != null) {
      SnackbarKitConfig.defaultBehavior = defaultBehavior;
    }
    if (defaultMargin != null) {
      SnackbarKitConfig.defaultMargin = defaultMargin;
    }
    if (showCloseButton != null) {
      SnackbarKitConfig.showCloseButton = showCloseButton;
    }
    if (showProgressIndicator != null) {
      SnackbarKitConfig.showProgressIndicator = showProgressIndicator;
    }
    if (progressIndicatorHeight != null) {
      SnackbarKitConfig.progressIndicatorHeight = progressIndicatorHeight;
    }
    if (defaultPosition != null) {
      SnackbarKitConfig.defaultPosition = defaultPosition;
    }
  }
}

/// Pre-defined color schemes for different snackbar types.
class SnackbarColors {
  SnackbarColors._();

  /// Success colors
  static const Color successBackground = Color(0xFF4CAF50);

  /// Success text
  static const Color successText = Colors.white;

  /// Error colors
  static const Color errorBackground = Color(0xFFE53935);

  /// Error text
  static const Color errorText = Colors.white;

  /// Warning colors
  static const Color warningBackground = Color(0xFFFF9800);

  /// Warning text
  static const Color warningText = Colors.white;

  /// Info colors
  static const Color infoBackground = Color(0xFF2196F3);

  /// Info text
  static const Color infoText = Colors.white;

  /// Normal/Default colors
  static const Color normalBackground = Color(0xFF616161);

  /// Normal/Default text
  static const Color normalText = Colors.white;
}

/// A utility class for displaying customizable snackbar notifications.
class SnackbarKit {
  /// Private constructor to prevent instantiation.
  SnackbarKit._();

  /// Shows a success snackbar with a checkmark icon.
  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    bool? showCloseButton,
    bool? showProgressIndicator,
    SnackbarPosition? position,
  }) {
    show(
      context,
      message: message,
      backgroundColor: SnackbarColors.successBackground,
      textColor: SnackbarColors.successText,
      icon: Icons.check_circle,
      duration: duration,
      action: action,
      showCloseButton: showCloseButton,
      showProgressIndicator: showProgressIndicator,
      position: position,
    );
  }

  /// Shows an error snackbar with an error icon.
  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    bool? showCloseButton,
    bool? showProgressIndicator,
    SnackbarPosition? position,
  }) {
    show(
      context,
      message: message,
      backgroundColor: SnackbarColors.errorBackground,
      textColor: SnackbarColors.errorText,
      icon: Icons.error,
      duration: duration,
      action: action,
      showCloseButton: showCloseButton,
      showProgressIndicator: showProgressIndicator,
      position: position,
    );
  }

  /// Shows a warning snackbar with a warning icon.
  static void warning(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    bool? showCloseButton,
    bool? showProgressIndicator,
    SnackbarPosition? position,
  }) {
    show(
      context,
      message: message,
      backgroundColor: SnackbarColors.warningBackground,
      textColor: SnackbarColors.warningText,
      icon: Icons.warning,
      duration: duration,
      action: action,
      showCloseButton: showCloseButton,
      showProgressIndicator: showProgressIndicator,
      position: position,
    );
  }

  /// Shows an info snackbar with an info icon.
  static void info(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    bool? showCloseButton,
    bool? showProgressIndicator,
    SnackbarPosition? position,
  }) {
    show(
      context,
      message: message,
      backgroundColor: SnackbarColors.infoBackground,
      textColor: SnackbarColors.infoText,
      icon: Icons.info,
      duration: duration,
      action: action,
      showCloseButton: showCloseButton,
      showProgressIndicator: showProgressIndicator,
      position: position,
    );
  }

  /// Shows a normal/default snackbar without a specific type.
  static void normal(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    bool? showCloseButton,
    bool? showProgressIndicator,
    SnackbarPosition? position,
  }) {
    show(
      context,
      message: message,
      backgroundColor: SnackbarColors.normalBackground,
      textColor: SnackbarColors.normalText,
      icon: null,
      duration: duration,
      action: action,
      showCloseButton: showCloseButton,
      showProgressIndicator: showProgressIndicator,
      position: position,
    );
  }

  /// Shows a custom snackbar with full control over appearance.
  /// Parameters:
  /// - [context]: BuildContext for showing the snackbar
  /// - [message]: The text message to display
  /// - [backgroundColor]: Background color (defaults to grey)
  /// - [textColor]: Text color (defaults to white)
  /// - [icon]: Optional icon to display before the message
  /// - [duration]: How long the snackbar stays visible
  /// - [action]: Optional action button
  /// - [behavior]: Fixed or floating (defaults to config)
  /// - [margin]: Margin around the snackbar (defaults to config)
  /// - [showCloseButton]: Whether to show close button (defaults to config)
  /// - [showProgressIndicator]: Whether to show countdown progress bar (defaults to config)
  /// - [position]: Position of snackbar (top or bottom, defaults to config)
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration? duration,
    SnackBarAction? action,
    SnackBarBehavior? behavior,
    EdgeInsets? margin,
    bool? showCloseButton,
    bool? showProgressIndicator,
    SnackbarPosition? position,
  }) {
    // Use provided values or fall back to config defaults
    final effectiveDuration = duration ?? SnackbarKitConfig.defaultDuration;
    final effectiveBehavior = behavior ?? SnackbarKitConfig.defaultBehavior;
    final effectiveMargin = margin ?? SnackbarKitConfig.defaultMargin;
    final effectiveShowClose =
        showCloseButton ?? SnackbarKitConfig.showCloseButton;
    final effectiveShowProgress =
        showProgressIndicator ?? SnackbarKitConfig.showProgressIndicator;
    final effectivePosition = position ?? SnackbarKitConfig.defaultPosition;
    final effectiveBackgroundColor =
        backgroundColor ?? SnackbarColors.normalBackground;
    final effectiveTextColor = textColor ?? Colors.white;

    // If position is TOP, use custom overlay
    if (effectivePosition == SnackbarPosition.top) {
      _showTopSnackbar(
        context,
        message: message,
        backgroundColor: effectiveBackgroundColor,
        textColor: effectiveTextColor,
        icon: icon,
        duration: effectiveDuration,
        action: action,
        margin: effectiveMargin,
        showCloseButton: effectiveShowClose,
        showProgressIndicator: effectiveShowProgress,
      );
      return;
    }

    // BOTTOM position - use native SnackBar
    if (effectiveShowProgress) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: _SnackbarContentWithProgress(
            message: message,
            icon: icon,
            textColor: effectiveTextColor,
            duration: effectiveDuration,
            progressColor: effectiveTextColor.withValues(alpha: 0.3),
            progressActiveColor: effectiveTextColor,
            isTop: false,
          ),
          backgroundColor: effectiveBackgroundColor,
          duration: effectiveDuration,
          behavior: effectiveBehavior,
          margin: effectiveBehavior == SnackBarBehavior.floating
              ? effectiveMargin
              : null,
          action: action,
          showCloseIcon: effectiveShowClose,
          closeIconColor: effectiveTextColor,
          padding: EdgeInsets.zero,
        ),
      );
    } else {
      final content = Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: effectiveTextColor, size: 24),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: effectiveTextColor, fontSize: 14),
            ),
          ),
        ],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: content,
          backgroundColor: effectiveBackgroundColor,
          duration: effectiveDuration,
          behavior: effectiveBehavior,
          margin: effectiveBehavior == SnackBarBehavior.floating
              ? effectiveMargin
              : null,
          action: action,
          showCloseIcon: effectiveShowClose,
          closeIconColor: effectiveTextColor,
        ),
      );
    }
  }

  /// Shows a snackbar at the top of the screen using Overlay.
  static void _showTopSnackbar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    required Duration duration,
    SnackBarAction? action,
    required EdgeInsets margin,
    required bool showCloseButton,
    required bool showProgressIndicator,
  }) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _TopSnackbar(
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        icon: icon,
        duration: duration,
        action: action,
        margin: margin,
        showCloseButton: showCloseButton,
        showProgressIndicator: showProgressIndicator,
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    overlayState.insert(overlayEntry);

    // Auto-dismiss after duration
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  /// Dismisses any currently visible snackbar.
  static void dismiss(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Removes all queued snackbars and dismisses the current one.
  static void clearAll(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

/// Custom snackbar widget for TOP position.
class _TopSnackbar extends StatefulWidget {
  const _TopSnackbar({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.duration,
    required this.margin,
    required this.showCloseButton,
    required this.showProgressIndicator,
    required this.onDismiss,
    this.icon,
    this.action,
  });

  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final Duration duration;
  final SnackBarAction? action;
  final EdgeInsets margin;
  final bool showCloseButton;
  final bool showProgressIndicator;
  final VoidCallback onDismiss;

  @override
  State<_TopSnackbar> createState() => _TopSnackbarState();
}

class _TopSnackbarState extends State<_TopSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Slide animation from top
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _slideController.forward();

    // Schedule slide out animation before dismiss
    Future.delayed(widget.duration - const Duration(milliseconds: 300), () {
      if (mounted) {
        _slideController.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          child: Padding(
            padding: widget.margin,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: widget.showProgressIndicator
                    ? _SnackbarContentWithProgress(
                        message: widget.message,
                        icon: widget.icon,
                        textColor: widget.textColor,
                        duration: widget.duration,
                        progressColor: widget.textColor.withValues(alpha: 0.3),
                        progressActiveColor: widget.textColor,
                        isTop: true,
                        action: widget.action,
                        showCloseButton: widget.showCloseButton,
                        onClose: widget.onDismiss,
                      )
                    : _SnackbarContent(
                        message: widget.message,
                        icon: widget.icon,
                        textColor: widget.textColor,
                        action: widget.action,
                        showCloseButton: widget.showCloseButton,
                        onClose: widget.onDismiss,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple snackbar content without progress indicator.
class _SnackbarContent extends StatelessWidget {
  const _SnackbarContent({
    required this.message,
    required this.textColor,
    required this.showCloseButton,
    required this.onClose,
    this.icon,
    this.action,
  });

  final String message;
  final IconData? icon;
  final Color textColor;
  final SnackBarAction? action;
  final bool showCloseButton;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                action!.onPressed();
                onClose();
              },
              child: Text(action!.label, style: TextStyle(color: textColor)),
            ),
          ],
          if (showCloseButton) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.close, color: textColor, size: 20),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Internal widget that wraps snackbar content with an animated progress indicator.
class _SnackbarContentWithProgress extends StatefulWidget {
  const _SnackbarContentWithProgress({
    required this.message,
    required this.duration,
    required this.textColor,
    required this.progressColor,
    required this.progressActiveColor,
    required this.isTop,
    this.icon,
    this.action,
    this.showCloseButton = false,
    this.onClose,
  });

  final String message;
  final IconData? icon;
  final Color textColor;
  final Duration duration;
  final Color progressColor;
  final Color progressActiveColor;
  final bool isTop;
  final SnackBarAction? action;
  final bool showCloseButton;
  final VoidCallback? onClose;

  @override
  State<_SnackbarContentWithProgress> createState() =>
      _SnackbarContentWithProgressState();
}

class _SnackbarContentWithProgressState
    extends State<_SnackbarContentWithProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create animation controller that counts down from 1.0 to 0.0
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Reverse animation (from 1.0 to 0.0) for countdown effect
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Start the countdown animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main content (icon + message)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: widget.textColor, size: 24),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(color: widget.textColor, fontSize: 14),
                ),
              ),
              if (widget.action != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.action!.onPressed();
                    widget.onClose?.call();
                  },
                  child: Text(
                    widget.action!.label,
                    style: TextStyle(color: widget.textColor),
                  ),
                ),
              ],
              if (widget.showCloseButton && widget.onClose != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.close, color: widget.textColor, size: 20),
                  onPressed: widget.onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
        ),

        // Progress bar always at BOTTOM
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
              child: LinearProgressIndicator(
                value: _animation.value,
                backgroundColor: widget.progressColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.progressActiveColor,
                ),
                minHeight: SnackbarKitConfig.progressIndicatorHeight,
              ),
            );
          },
        ),
      ],
    );
  }
}
