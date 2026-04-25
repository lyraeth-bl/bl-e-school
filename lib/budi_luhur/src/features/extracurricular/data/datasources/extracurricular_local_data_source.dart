import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_box_keys/hive_box_keys.dart';
import '../model/extracurricular/extracurricular.dart';

abstract class ExtracurricularLocalDataSource {
  List<Extracurricular>? getStoredExtracurricular();

  Future<Unit> saveExtracurricular(List<Extracurricular> listExtracurricular);
}

class ExtracurricularLocalDataSourceImpl
    implements ExtracurricularLocalDataSource {
  @override
  List<Extracurricular>? getStoredExtracurricular() {
    final raw = Hive.box(sessionsBoxKey).get(sessionsListExtracurricularKey);

    if (raw == null) return null;

    final list = (raw as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return list.map((e) => Extracurricular.fromJson(e)).toList();
  }

  @override
  Future<Unit> saveExtracurricular(
    List<Extracurricular> listExtracurricular,
  ) async {
    final jsonList = listExtracurricular.map((e) => e.toJson()).toList();

    await Hive.box(
      sessionsBoxKey,
    ).put(sessionsListExtracurricularKey, jsonList);

    return unit;
  }
}
