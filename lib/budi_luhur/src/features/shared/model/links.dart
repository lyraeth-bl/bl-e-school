import 'package:freezed_annotation/freezed_annotation.dart';

part 'links.freezed.dart';
part 'links.g.dart';

/// Represents a navigation link, typically used for pagination in API responses.
///
/// This model is commonly found in paginated API results, where it provides
/// URLs and labels for navigating between pages (e.g., "next", "previous",
/// or page numbers).
@freezed
abstract class Links with _$Links {
  /// Creates an instance of a [Links] object.
  const factory Links({
    /// The URL for the navigation link.
    ///
    /// This can be `null` for certain links, such as the current page indicator
    /// where a URL is not needed.
    @JsonKey(name: "url") String? url,

    /// The display text for the link.
    ///
    /// This could be a page number, "Next &raquo;", or "&laquo; Previous".
    @JsonKey(name: "label") required String label,

    /// A flag indicating whether this link represents the current, active page.
    @JsonKey(name: "active") required bool active,
  }) = _Links;

  /// Creates a [Links] instance from a JSON map.
  ///
  /// This factory is used for deserializing the JSON response from the API
  /// into a `Links` object.
  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
}
