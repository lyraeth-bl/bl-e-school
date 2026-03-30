class ErrorMessageKeysAndCode {
  static const String defaultErrorMessageKey = "defaultErrorMessage";
  static const String noInternetKey = "noInternet";
  static const String internetServerErrorKey = "internetServerError";
  static const String permissionsNotGivenKey = "permissionsNotGiven";
  static const String fileDownloadingFailedKey = "fileDownloadingFailed";

  static const String shareAppLinkKey = "shareAppLink";
  static const String rateAppLinkKey = "rateAppLink";

  static const String invalidLogInCredentialsKey = "invalidLogInCredentials";
  static const String unauthenticatedAccessKey = "unauthenticatedAccess";
  static const String invalidUserDetailsKey = "invalidUserDetails";
  static const String invalidPasswordKey = "invalidPassword";
  static const String canNotSendResetPasswordRequestKey =
      "canNotSendResetPasswordRequest";
  static const String inactiveChildKey = "inactiveChild";
  static const String inactiveAccountKey = "inactiveAccount";

  static const String assignmentAlreadySubmittedKey =
      "assignmentAlreadySubmitted";
  static const String examOnlineAttendedKey = "examOnlineAttended";
  static const String examOnlineNotStartedYetKey = "examOnlineNotStartedYet";
  static const String noOnlineExamReportFoundKey = "noOnlineExamReportFound";
  static const String paymentFailedKey = "paymentFailed";
  static const String notAllowedInDemoVersionKey =
      "This is not allowed in the Demo Version.";

  static const String internetServerErrorCode = "500";
  static const String fileNotFoundErrorCode = "404";
  static const String unauthenticatedErrorCode = "401";
  static const String permissionNotGivenCode = "300";
  static const String noInternetCode = "301";
  static const String defaultErrorMessageCode = "302";
  static const String noOnlineExamReportFoundCode = "303";
  static const String notAllowedInDemoVersionCode = "112";
  static const String inactiveChildCode = "115";
  static const String inactiveAccountCode = "116";

  static String getErrorMessageKeyFromCode(String errorCode) {
    switch (errorCode) {
      case "101":
        return invalidLogInCredentialsKey;
      case "104":
        return assignmentAlreadySubmittedKey;
      case "105":
        return examOnlineAttendedKey;
      case "106":
        return examOnlineNotStartedYetKey;
      case "107":
        return invalidUserDetailsKey;
      case "108":
        return canNotSendResetPasswordRequestKey;
      case "109":
        return invalidPasswordKey;
      case notAllowedInDemoVersionCode:
        return notAllowedInDemoVersionKey;
      case noOnlineExamReportFoundCode:
        return noOnlineExamReportFoundKey;
      case permissionNotGivenCode:
        return permissionsNotGivenKey;
      case noInternetCode:
        return noInternetKey;
      case internetServerErrorCode:
        return internetServerErrorKey;
      case fileNotFoundErrorCode:
        return fileDownloadingFailedKey;
      case defaultErrorMessageCode:
        return defaultErrorMessageKey;
      case inactiveChildCode:
        return inactiveChildKey;
      case inactiveAccountCode:
        return inactiveAccountKey;
      case unauthenticatedErrorCode:
        return unauthenticatedAccessKey;
      default:
        return defaultErrorMessageKey;
    }
  }
}
