import 'package:flutter/material.dart';
import 'package:hisab_kitab/app/app.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(App());
}
