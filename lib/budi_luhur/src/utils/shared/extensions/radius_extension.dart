import 'package:flutter/material.dart';

/// Provides extensions for creating [BorderRadius] objects more conveniently.
///
/// This file contains two extensions:
/// 1. [RadiusExtension] on [num] to create a circular [BorderRadius] from a number.
/// 2. [CustomRadiusExtension] on [BorderRadius] to provide a pre-defined custom border radius.

/// An extension on [num] to simplify the creation of circular [BorderRadius].
///
/// Example:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     // Instead of BorderRadius.circular(16.0)
///     borderRadius: 16.circular,
///     color: Colors.blue,
///   ),
/// )
/// ```
extension RadiusExtension on num {
  /// Creates a [BorderRadius] with a circular radius equal to the number's value.
  BorderRadius get circular => BorderRadius.circular(toDouble());

  BorderRadius get topRadiusCircular => BorderRadius.only(
    topLeft: Radius.circular(toDouble()),
    topRight: Radius.circular(toDouble()),
  );

  BorderRadius get bottomRadiusCircular => BorderRadius.only(
    bottomLeft: Radius.circular(toDouble()),
    bottomRight: Radius.circular(toDouble()),
  );
}

/// An extension on [BorderRadius] to provide a pre-defined custom border radius.
///
/// This can be used for consistently styled containers throughout the app.
///
/// Example:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: BorderRadius.customContainer,
///     color: Colors.red,
///   ),
/// )
/// ```
extension CustomRadiusExtension on BorderRadius {
  /// A custom [BorderRadius] with the following values:
  /// - topLeft: 32.0
  /// - topRight: 16.0
  /// - bottomLeft: 16.0
  /// - bottomRight: 32.0
  static BorderRadius customContainerRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(32),
    topLeft: Radius.circular(32),
    topRight: Radius.circular(16),
  );
}
