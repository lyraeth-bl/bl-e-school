import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHiveOpenBox() async {
  await Hive.initFlutter();

  await Hive.openBox(showCaseBoxKey);
  await Hive.openBox(sessionsBoxKey);
  await Hive.openBox(notificationsBoxKey);
  await Hive.openBox(settingsBoxKey);
}
