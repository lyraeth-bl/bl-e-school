import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_dto.freezed.dart';
part 'feedback_dto.g.dart';

/// Represents a Data Transfer Object (DTO) for feedback data.
///
/// This class is used to structure the response from the feedback API. It
/// encapsulates a list of [Feedback] objects, which aligns with the expected
/// JSON structure from the server. Using a DTO like this allows for robust
/// and type-safe parsing of the API response.
///
/// This class is immutable and is generated using the `freezed` and `json_serializable`
/// packages.
@freezed
abstract class FeedbackDTO with _$FeedbackDTO {
  /// Creates a new [FeedbackDTO] instance.
  ///
  /// The factory constructor takes a list of [Feedback] objects, which is
  /// the primary payload of this DTO.
  const factory FeedbackDTO({
    /// A list of feedback items.
    required List<Feedback> feedbackList,
  }) = _FeedbackDTO;

  /// Creates a [FeedbackDTO] from a JSON map.
  ///
  /// This factory is used by `json_serializable` to deserialize a JSON object
  /// into a [FeedbackDTO] instance.
  factory FeedbackDTO.fromJson(Map<String, dynamic> json) =>
      _$FeedbackDTOFromJson(json);
}
