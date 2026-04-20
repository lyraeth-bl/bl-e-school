import 'package:hive_flutter/hive_flutter.dart';

import '../../core/storage/hive_box_keys/hive_box_keys.dart';

Future<void> initHiveOpenBox() async {
  await Hive.initFlutter();

  await Hive.openBox(showCaseBoxKey);
  await Hive.openBox(sessionsBoxKey);
  await Hive.openBox(notificationsBoxKey);
  await Hive.openBox(settingsBoxKey);
}
