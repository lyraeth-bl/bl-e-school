import 'package:bl_e_school/budi_luhur/src/utils/shared/hive_box_keys/hive_box_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<Unit> closeAndDeleteBox();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<Unit> closeAndDeleteBox() async {
    final List<String> namesBox = [
      notificationsBoxKey,
      attendanceBoxKey,
      feedbackBoxKey,
    ];

    for (var name in namesBox) {
      if (Hive.isBoxOpen(name)) {
        debugPrint("Closing $name box");
        await Hive.box(name).close();
      }
      debugPrint("Deleting $name box");
      await Hive.deleteBoxFromDisk(name);
    }

    return unit;
  }
}
