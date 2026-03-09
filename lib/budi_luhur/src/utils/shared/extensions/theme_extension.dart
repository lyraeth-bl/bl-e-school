import 'package:flutter/material.dart';

/// An extension on [BuildContext] to provide convenient access to [ThemeData] properties.
///
/// This extension simplifies accessing the [ColorScheme] and [TextTheme] from the
/// current theme.
///
/// Example:
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       // Use the primary color from the theme's color scheme.
///       color: context.colors.primary,
///       child: Text(
///         'Hello World',
///         // Use the headline6 text style from the theme's text theme.
///         style: context.textTheme.headline6,
///       ),
///     );
///   }
/// }
/// ```
extension ThemeExtension on BuildContext {
  /// Returns the [ColorScheme] from the current [Theme].
  ///
  /// This is a shortcut for `Theme.of(this).colorScheme`.
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Returns the [TextTheme] from the current [Theme].
  ///
  /// This is a shortcut for `Theme.of(this).textTheme`.
  TextTheme get text => Theme.of(this).textTheme;
}
