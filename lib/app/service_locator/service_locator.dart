import 'package:get_it/get_it.dart';
import 'package:hisab_kitab/core/network/hive_service.dart';
import 'package:hisab_kitab/features/auth/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:hisab_kitab/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  _initHiveService();
  _initSplashModule();
  _initLoginModule();
  _initSignupModule();
  _initHomeModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future _initLoginModule() async {
  serviceLocator.registerFactory(
    () => UserLoginUsecase(repository: serviceLocator<UserLocalRepository>()),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

Future _initSignupModule() async {
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDataSource: serviceLocator<UserLocalDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () =>
        UserRegisterUsecase(repository: serviceLocator<UserLocalRepository>()),
  );

  serviceLocator.registerFactory(
    () => SignupViewModel(serviceLocator<UserRegisterUsecase>()),
  );
}

Future _initHomeModule() async {
  serviceLocator.registerLazySingleton(() => HomeViewModel());
}
