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
