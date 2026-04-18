import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum ToastType { error, success, warning, info }

enum ToastPosition { top, bottom }

class AppToast {
  static OverlayEntry? _currentEntry;

  /// Displays a custom toast on the screen.
  ///
  /// [forShowOnMenuScreen] should be set to `true` if the toast is displayed on
  /// a screen that has a Bottom Navigation Bar. This provides additional
  /// bottom padding so the toast is not obscured by the navigation bar.
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.error,
    Duration duration = const Duration(seconds: 3),
    bool forShowOnMenuScreen = false,
    IconData? customIcon,
    OverlayState? overlayState,
    ToastPosition position = ToastPosition.bottom,
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = overlayState ?? Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        message: message,
        type: type,
        onDismiss: () {
          entry.remove();
          _currentEntry = null;
        },
        duration: duration,
        forShowOnMenuScreen: forShowOnMenuScreen,
        customIcon: customIcon,
        position: position,
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;
  final Duration duration;
  final IconData? customIcon;
  final ToastPosition position;

  /// Whether the toast is displayed on a screen with a Bottom Navigation Bar.
  /// If `true`, additional bottom padding is applied to avoid overlap.
  final bool forShowOnMenuScreen;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
    required this.duration,
    this.forShowOnMenuScreen = false,
    this.customIcon,
    this.position = ToastPosition.bottom,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnim = Tween<Offset>(
      begin: widget.position == ToastPosition.top
          ? const Offset(0, -1.5)
          : const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // auto dismiss
    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData get _icon =>
      widget.customIcon ??
      switch (widget.type) {
        ToastType.error => LucideIcons.ban,
        ToastType.success => LucideIcons.circleCheck,
        ToastType.warning => LucideIcons.circleAlert,
        ToastType.info => LucideIcons.info,
      };

  Color get _backgroundColor => switch (widget.type) {
    ToastType.error => context.colors.errorContainer,
    ToastType.success => Colors.greenAccent.shade100,
    ToastType.warning => Colors.yellowAccent.shade100,
    ToastType.info => context.colors.primaryContainer,
  };

  Color get _textColor => switch (widget.type) {
    ToastType.error => context.colors.onErrorContainer,
    ToastType.success => Colors.black,
    ToastType.warning => Colors.black,
    ToastType.info => context.colors.onPrimaryContainer,
  };

  Color get _iconColor => switch (widget.type) {
    ToastType.error => context.colors.onErrorContainer,
    ToastType.success => Colors.black,
    ToastType.warning => Colors.black,
    ToastType.info => context.colors.onPrimaryContainer,
  };

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position == ToastPosition.top
          ? context.padding.top + 24
          : null,
      bottom: widget.position == ToastPosition.bottom
          ? (widget.forShowOnMenuScreen
                ? context.padding.bottom + 104
                : context.padding.bottom + 24)
          : null,
      left: 48,
      right: 48,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _dismiss,
              child: CustomContainer(
                border: Border.all(
                  color: context.colors.outlineVariant.withValues(alpha: 0.2),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                backgroundColor: _backgroundColor,
                enableShadow: false,
                child: Row(
                  children: [
                    Icon(_icon, color: _iconColor),
                    16.w,
                    Expanded(
                      child: Text(
                        widget.message,
                        style: context.text.bodyMedium?.copyWith(
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Icon(
                        LucideIcons.circleX,
                        color: _textColor,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
