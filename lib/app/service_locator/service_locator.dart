import 'package:get_it/get_it.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  _initSplashModule();
}

Future _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}
