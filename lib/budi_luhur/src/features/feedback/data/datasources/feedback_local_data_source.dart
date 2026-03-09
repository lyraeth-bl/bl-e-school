import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

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
