import 'package:shared_preferences/shared_preferences.dart';

import '../../dependencies_injection/get_it_instance.dart';

part 'prefs_storage_label.dart';

Future<void> initPrefsDI() async {
  final prefs = await SharedPreferences.getInstance();

  sI.registerSingleton<SharedPreferences>(prefs);
}
