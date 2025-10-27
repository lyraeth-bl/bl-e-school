/// A custom exception class for handling API-related errors.
///
/// This exception is thrown when an API call fails or returns an error.
/// It encapsulates a user-friendly error message that can be displayed
/// to the user.
class ApiException implements Exception {
  /// The error message associated with this exception.
  String errorMessage;

  /// Creates a new instance of [ApiException].
  ///
  /// [errorMessage] is the descriptive message for the error.
  ApiException(this.errorMessage);

  /// Returns the string representation of the exception.
  @override
  String toString() {
    return errorMessage;
  }
}
