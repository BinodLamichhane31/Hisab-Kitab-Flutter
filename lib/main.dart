import 'package:flutter/material.dart';
import 'package:hisab_kitab/app/app.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await HiveService().init();

  // final tokenSharedPref = serviceLocator<TokenSharedPrefs>();
  // final token = await tokenSharedPref.getToken();
  // debugPrint("Shared Pref Token: $token");

  // await HiveService().clearAllBoxes();

  // final box = await Hive.openBox<UserHiveModel>('authBox');
  // for (var user in box.values) {
  //   debugPrint(user.toString());
  // }

  runApp(App());
}
