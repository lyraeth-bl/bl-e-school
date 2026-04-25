import 'package:flutter/material.dart';

import 'budi_luhur/src/app/budi_luhur_app.dart';
import 'budi_luhur/src/app/budi_luhur_initialize_app.dart';

void main() async {
  await budiLuhurInitializeApp();

  runApp(BudiLuhurApp());
}
