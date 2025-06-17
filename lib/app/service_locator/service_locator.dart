import 'package:get_it/get_it.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  _initSplashModule();
  _initLoginModule();
  _initSignupModule();
  _initHomeModule();
}

Future _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future _initLoginModule() async {
  serviceLocator.registerFactory(() => LoginViewModel());
}

Future _initSignupModule() async {
  serviceLocator.registerFactory(() => SignupViewModel());
}

Future _initHomeModule() async {
  serviceLocator.registerLazySingleton(() => HomeViewModel());
}
