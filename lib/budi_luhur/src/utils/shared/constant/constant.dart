/// The duration for which an error message is displayed on the screen.
const Duration errorMessageDisplayDuration = Duration(milliseconds: 3000);

// --- Animations Configuration ---

/// A global flag to enable or disable all item appearance animations throughout the application.
/// If set to `false`, all related animations will be turned off.
const bool isApplicationItemAnimationOn = true;

/// The delay in milliseconds between the animation of each item in a list.
/// Note: Values less than 10 may result in unexpected behavior.
const int listItemAnimationDelayInMilliseconds = 100;

/// The duration in milliseconds for item fade-in animations.
const int itemFadeAnimationDurationInMilliseconds = 250;

/// The duration in milliseconds for item zoom-in animations.
const int itemZoomAnimationDurationInMilliseconds = 200;

/// The duration in milliseconds for item bounce and scale animations.
const int itemBounceScaleAnimationDurationInMilliseconds = 200;

/// The duration in millisecond for menu bottom sheet
const Duration homeMenuBottomSheetAnimationDuration = Duration(
  milliseconds: 300,
);

// --------------------------------------------------------------------------
// --                          MODULE IDENTIFIERS                          --
// --------------------------------------------------------------------------
//
// WARNING: PLEASE DO NOT MODIFY THESE MODULE IDS.
//
// These integer constants are unique identifiers for various modules within
// the application. They are used to control access, navigation, and data
// management for different features. Modifying these values will break
// feature recognition and can lead to critical application failures.
//
// --------------------------------------------------------------------------

/// The unique identifier for the Student Management module.
const int studentManagementModuleId = 1;

/// The unique identifier for the Academics Management module.
const int academicsManagementModuleId = 2;

/// The unique identifier for the Slider Management module.
const int sliderManagementModuleId = 3;

/// The unique identifier for the Teacher Management module.
const int teacherManagementModuleId = 4;

/// The unique identifier for the Session Year Management module.
const int sessionYearManagementId = 5;

/// The unique identifier for the Holiday Management module.
const int holidayManagementModuleId = 6;

/// The unique identifier for the Timetable Management module.
const int timetableManagementModuleId = 7;

/// The unique identifier for the Attendance Management module.
const int attendanceManagementModuleId = 8;

/// The unique identifier for the Exam Management module.
const int examManagementModuleId = 9;

/// The unique identifier for the Lesson Management module.
const int lessonManagementModuleId = 10;

/// The unique identifier for the Assignment Management module.
const int assignmentManagementModuleId = 11;

/// The unique identifier for the Announcement Management module.
const int announcementManagementModuleId = 12;

/// The unique identifier for the Staff Management module.
const int staffManagementModuleId = 13;

/// The unique identifier for the Expense Management module.
const int expenseManagementModuleId = 14;

/// The unique identifier for the Staff Leave Management module.
const int staffLeaveManagementModuleId = 15;

/// The unique identifier for the Fees Management module.
const int feesManagementModuleId = 16;

/// The unique identifier for the Gallery Management module.
const int galleryManagementModuleId = 17;

/// The unique identifier for the Chat module.
const int chatModuleId = 20;

/// The unique identifier for the academic calendar module.
const int academicCalendarModuleId = 21;

/// A default module ID, used as a fallback or for unassigned modules.
const int defaultModuleId = -1;

/// A character used to join module IDs, for creating compound identifiers.
const String moduleIdJoiner = "#";
