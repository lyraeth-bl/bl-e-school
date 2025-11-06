part of 'notifications_cubit.dart';

/// Represents the different states for the [NotificationsCubit].
///
/// This sealed class defines the possible states related to fetching
/// and displaying notifications, allowing the UI to react accordingly.
@freezed
abstract class NotificationsState with _$NotificationsState {
  /// The initial state of the cubit.
  ///
  /// This is the default state before any notification-related operations have begun.
  const factory NotificationsState.initial() = _Initial;

  /// The loading state.
  ///
  /// This state indicates that notifications are currently being fetched from the
  /// repository or an external data source.
  const factory NotificationsState.loading() = _Loading;

  /// The success state.
  ///
  /// This state signifies that the notifications have been successfully retrieved.
  /// It holds the [listNotifications] that can be displayed by the UI.
  const factory NotificationsState.success({
    /// The list of successfully fetched notifications.
    required List<NotificationsDetails> listNotifications,
  }) = _Success;

  /// The failure state.
  ///
  /// This state indicates that an error occurred while trying to fetch the
  /// notifications. It contains an [errorMessage] describing what went wrong.
  const factory NotificationsState.failure(String errorMessage) = _Failure;
}
