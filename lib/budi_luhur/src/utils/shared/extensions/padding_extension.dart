import 'package:flutter/material.dart';

/// An extension on [num] to provide convenient padding shortcuts.
///
/// This extension simplifies the creation of [EdgeInsets] objects for padding.
///
/// Example:
/// ```dart
/// // Instead of EdgeInsets.all(16.0)
/// final padding = 16.all;
///
/// // Instead of EdgeInsets.symmetric(horizontal: 24.0)
/// final horizontalPadding = 24.horizontal;
///
/// // Instead of EdgeInsets.symmetric(vertical: 8.0)
/// final verticalPadding = 8.vertical;
/// ```
extension PaddingExtension on num {
  /// Creates an [EdgeInsets] object with the same padding value for all sides.
  EdgeInsets get all => EdgeInsets.all(toDouble());

  /// Creates an [EdgeInsets] object with the same padding value for the left and right sides.
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());

  /// Creates an [EdgeInsets] object with the same padding value for the top and bottom sides.
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get onlyRigth => EdgeInsets.only(right: toDouble());

  EdgeInsets get onlyLeft => EdgeInsets.only(left: toDouble());

  EdgeInsets get onlyTop => EdgeInsets.only(top: toDouble());

  EdgeInsets get onlyBottom => EdgeInsets.only(bottom: toDouble());
}
