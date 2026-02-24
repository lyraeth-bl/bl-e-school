import 'package:flutter/material.dart';

/// An extension on [BuildContext] to easily access media query properties.
///
/// This extension provides convenient getters for common media query data,
/// reducing boilerplate code.
///
/// Example:
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     // Access screen width and height directly from the context.
///     final width = context.screenWidth;
///     final height = context.screenHeight;
///
///     return Container(
///       width: width * 0.5, // 50% of screen width
///       height: height * 0.25, // 25% of screen height
///       child: Text('Hello!'),
///     );
///   }
/// }
/// ```
extension MediaQueryExtension on BuildContext {
  /// Returns the [Size] of the media.
  ///
  /// This is equivalent to `MediaQuery.of(this).size`.
  Size get screenSize => MediaQuery.of(this).size;

  /// Returns the width of the media in logical pixels.
  ///
  /// This is equivalent to `MediaQuery.of(this).size.width`.
  double get screenWidth => screenSize.width;

  /// Returns the height of the media in logical pixels.
  ///
  /// This is equivalent to `MediaQuery.of(this).size.height`.
  double get screenHeight => screenSize.height;

  /// Returns the parts of the display that are completely obscured by system UI,
  /// typically by the device's keyboard.
  ///
  /// This is equivalent to `MediaQuery.of(this).viewInsets`.
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// This is equivalent to `MediaQuery.of(this).padding`.
  EdgeInsets get padding => MediaQuery.of(this).padding;
}
