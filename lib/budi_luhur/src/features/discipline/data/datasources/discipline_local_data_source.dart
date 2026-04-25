import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_box_keys/hive_box_keys.dart';
import '../model/demerit/demerit.dart';
import '../model/merit/merit.dart';

abstract class DisciplineLocalDataSource {
  List<Merit>? getStoredMerit();

  Future<Unit> storeMerit(List<Merit> listMerit);

  List<Demerit>? getStoredDemerit();

  Future<Unit> storeDemerit(List<Demerit> listDemerit);
}

class DisciplineLocalDataSourceImpl implements DisciplineLocalDataSource {
  @override
  List<Demerit>? getStoredDemerit() {
    final raw = Hive.box(sessionsBoxKey).get(sessionsListDemeritKey);

    if (raw == null) return null;

    final list = (raw as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return list.map((e) => Demerit.fromJson(e)).toList();
  }

  @override
  List<Merit>? getStoredMerit() {
    final raw = Hive.box(sessionsBoxKey).get(sessionsListMeritKey);

    if (raw == null) return null;

    final list = (raw as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return list.map((e) => Merit.fromJson(e)).toList();
  }

  @override
  Future<Unit> storeDemerit(List<Demerit> listDemerit) async {
    final jsonList = listDemerit.map((e) => e.toJson()).toList();

    await Hive.box(sessionsBoxKey).put(sessionsListDemeritKey, jsonList);

    return unit;
  }

  @override
  Future<Unit> storeMerit(List<Merit> listMerit) async {
    final jsonList = listMerit.map((e) => e.toJson()).toList();

    await Hive.box(sessionsBoxKey).put(sessionsListMeritKey, jsonList);

    return unit;
  }
}
