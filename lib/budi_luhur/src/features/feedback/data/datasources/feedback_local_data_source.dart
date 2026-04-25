import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_box_keys/hive_box_keys.dart';
import '../model/feedback/feedback.dart';

abstract class FeedbackLocalDataSource {
  Future<Unit> saveFeedback(List<Feedback> listFeedback);

  List<Feedback>? getStoredFeedback();
}

class FeedbackLocalDataSourceImpl implements FeedbackLocalDataSource {
  @override
  List<Feedback>? getStoredFeedback() {
    final raw = Hive.box(sessionsBoxKey).get(sessionsListFeedbackKey);

    if (raw == null) return null;

    final list = (raw as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return list.map((e) => Feedback.fromJson(e)).toList();
  }

  @override
  Future<Unit> saveFeedback(List<Feedback> listFeedback) async {
    final jsonList = listFeedback.map((e) => e.toJson()).toList();

    await Hive.box(sessionsBoxKey).put(sessionsListFeedbackKey, jsonList);

    return unit;
  }
}
