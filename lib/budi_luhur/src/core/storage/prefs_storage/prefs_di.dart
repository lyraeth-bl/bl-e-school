import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs_storage_label.dart';

Future<void> initPrefsDI() async {
  final prefs = await SharedPreferences.getInstance();

  sI.registerSingleton<SharedPreferences>(prefs);
}
