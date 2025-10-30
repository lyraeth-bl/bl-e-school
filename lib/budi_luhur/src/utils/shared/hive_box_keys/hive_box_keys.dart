/// Contains keys for the showcase feature to guide users through the app.
const String showCaseBoxKey = "showCaseBox";

/// A key to check if the home screen guide has been shown.
const String showHomeScreenGuideKey = "showHomeScreenGuide";

/// Contains keys related to authentication and user session data.
const String authBoxKey = "authBox";

/// The key for storing the JWT token.
const String jwtTokenKey = "authBox.jwtToken";

/// A flag to indicate if a user is logged in.
const String isLogInKey = "authBox.isLogIn";

/// The key for storing the school code.
const String schoolCodeKey = "authBox.schoolCode";

/// A flag to indicate if the logged-in user is a student.
const String isStudentLogInKey = "authBox.isStudentLogIn";

/// The key for storing student details.
const String studentDetailsKey = "authBox.studentDetails";

/// The key for storing parent details.
const String parentDetailsKey = "authBox.parentDetails";

/// Contains keys related to student subjects.
const String studentSubjectsBoxKey = "authBox.studentSubjectsBox";

/// The key for storing the student's core subjects.
const String coreSubjectsHiveKey = "authBox.coreSubjects";

/// The key for storing the student's elective subjects.
const String electiveSubjectsHiveKey = "authBox.electiveSubjects";

/// Contains keys for caching student attendance data.
const String attendanceBoxKey = 'attendanceBox';

/// The key for storing the student's daily attendance record.
const String studentDailyAttendanceKey = 'attendanceBox.dailyAttendance';

/// A flag to check if the daily attendance has been posted.
const String studentHasPostDailyAttendanceKey =
    "attendanceBox.hasPostDailyAttendance";

/// A flag to check if the student has checked in for the day.
const String studentHasCheckInKey = "attendanceBox.hasCheckIn";

/// A flag to check if the student has checked out for the day.
const String studentHasCheckOutKey = "attendanceBox.hasCheckOut";

/// Contains keys for various application settings.
const String settingsBoxKey = "settingsBox";

/// The key for storing the current language code of the app.
const String currentLanguageCodeKey = "settingsBoxCurrentLanguageCode";

/// A flag to determine if notifications are allowed.
const String allowNotificationKey = "settingsBoxAllowNotification";

/// The box key for parent-specific data.
const String parentBoxKey = "parentBox";

/// The box key for student-specific data.
const String studentBoxKey = "studentBox";

/// Contains keys related to notifications.
const String notificationsBoxKey = "notificationsBox";

/// The key for temporarily storing notifications.
const String temporarilyStoredNotificationsKey =
    "notificationsBox.temporarilyStoredNotifications";
