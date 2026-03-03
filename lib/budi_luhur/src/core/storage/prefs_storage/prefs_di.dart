import 'package:bl_e_school/budi_luhur/src/core/dependencies_injection/get_it_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initPrefsDI() async {
  final prefs = await SharedPreferences.getInstance();

  sI.registerSingleton<SharedPreferences>(prefs);
}
