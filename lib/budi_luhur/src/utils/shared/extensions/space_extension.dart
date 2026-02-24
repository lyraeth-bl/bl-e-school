import 'package:flutter/material.dart';

/// An extension on [num] to easily create [SizedBox] widgets for spacing.
///
/// This extension provides convenient getters to create horizontal and vertical
/// spacing in a more concise way.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('Widget 1'),
///     16.h, // Creates a SizedBox(height: 16.0)
///     Text('Widget 2'),
///   ],
/// )
///
/// Row(
///   children: [
///     Text('Widget A'),
///     8.w, // Creates a SizedBox(width: 8.0)
///     Text('Widget B'),
///   ],
/// )
/// ```
extension SpaceExtension on num {
  /// Creates a [SizedBox] with a height equal to the number's value.
  ///
  /// This is a shortcut for `SizedBox(height: toDouble())`.
  SizedBox get h => SizedBox(height: toDouble());

  /// Creates a [SizedBox] with a width equal to the number's value.
  ///
  /// This is a shortcut for `SizedBox(width: toDouble())`.
  SizedBox get w => SizedBox(width: toDouble());
}

/// An extension on a list of widgets to provide spacing capabilities.
///
/// This extension simplifies the process of adding a separator widget
/// between each item in a list of widgets.
extension SpacingExtension on List<Widget> {
  /// Inserts a [separator] widget between each widget in the list.
  ///
  /// This is useful for adding consistent spacing between items in a
  /// [Column] or [Row].
  ///
  /// Example:
  /// ```dart
  /// Column(
  ///   children: <Widget>[
  ///     Text('Item 1'),
  ///     Text('Item 2'),
  ///     Text('Item 3'),
  ///   ].separatedBy(SizedBox(height: 16.0)),
  /// )
  /// ```
  ///
  /// ```dart
  /// Row(
  ///   children: <Widget>[
  ///     Text('Item 1'),
  ///     Text('Item 2'),
  ///     Text('Item 3'),
  ///   ].separatedBy(SizedBox(width: 16.0)),
  /// )
  /// ```
  ///
  /// This will produce a column/row with a 16.0 pixel space between each text widget.
  List<Widget> separatedBy(Widget separator) {
    if (length < 2) return this;
    final spaced = <Widget>[];
    for (var i = 0; i < length; i++) {
      spaced.add(this[i]);
      if (i != length - 1) spaced.add(separator);
    }
    return spaced;
  }
}
