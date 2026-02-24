/// An extension on the [String] class to provide utility methods for string manipulation and validation.
///
/// This extension includes methods to check for SVG URLs and validate general URL formats.
extension StringExtensions on String {
  /// Checks if the string, treated as a URL, ends with the `.svg` extension.
  ///
  /// This method is case-insensitive for the 'svg' part.
  /// Returns `false` if the string is empty.
  ///
  /// Example:
  /// ```dart
  /// print('image.svg'.isSvgUrl());       // Outputs: true
  /// print('image.SVG'.isSvgUrl());       // Outputs: true
  /// print('image.png'.isSvgUrl());       // Outputs: false
  /// print('https://example.com/icon.svg'.isSvgUrl()); // Outputs: true
  /// print(''.isSvgUrl());                // Outputs: false
  /// ```
  bool isSvgUrl() {
    if (isEmpty) return false;
    final parts = split('.');
    return parts.isNotEmpty && parts.last.toLowerCase() == 'svg';
  }

  /// Checks if the string represents a valid HTTP or HTTPS URL.
  ///
  /// It uses [Uri.tryParse] to validate the string. A valid URL must have
  /// either an 'http' or 'https' scheme.
  /// Returns `false` if the string is empty or cannot be parsed into a valid URI.
  ///
  /// Example:
  /// ```dart
  /// print('https://www.google.com'.isValidUrl()); // Outputs: true
  /// print('http://example.com'.isValidUrl());    // Outputs: true
  /// print('ftp://example.com'.isValidUrl());     // Outputs: false
  /// print('not a valid url'.isValidUrl());       // Outputs: false
  /// print(''.isValidUrl());                      // Outputs: false
  /// ```
  bool isValidUrl() {
    if (isEmpty) return false;
    final uri = Uri.tryParse(this);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}
