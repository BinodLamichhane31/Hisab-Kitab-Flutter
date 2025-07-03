import 'package:flutter/material.dart';
import 'package:hisab_kitab/app/app.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/core/network/hive_service.dart';
import 'package:hisab_kitab/features/auth/data/model/user_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await HiveService().init();

  // await HiveService().clearAllBoxes();

  // final box = await Hive.openBox<UserHiveModel>('authBox');
  // for (var user in box.values) {
  //   debugPrint(user.toString());
  // }

  runApp(App());
}
