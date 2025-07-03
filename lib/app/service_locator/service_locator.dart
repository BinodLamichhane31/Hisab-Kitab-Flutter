import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/core/network/hive_service.dart';
import 'package:hisab_kitab/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:hisab_kitab/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/get_profile_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_logout_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await _initSharedPreference();
  await _initHiveService();
  await _initApiService();
  await _initSplashModule();
  await _initLoginModule();
  await _initSignupModule();
  await _initHomeModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(
    () => ApiService(Dio(), serviceLocator<TokenSharedPrefs>()),
  );
}

Future _initSharedPreference() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future _initSplashModule() async {
  serviceLocator.registerFactory(
    () => SplashViewModel(serviceLocator<TokenSharedPrefs>()),
  );
}

Future _initLoginModule() async {
  serviceLocator.registerFactory(
    () => UserLogoutUsecase(serviceLocator<TokenSharedPrefs>()),
  );

  serviceLocator.registerFactory(
    () => GetProfileUsecase(serviceLocator<UserRemoteRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      repository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

Future _initSignupModule() async {
  serviceLocator.registerFactory(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );
  // serviceLocator.registerFactory(
  //   () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  // );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDataSource: serviceLocator<UserRemoteDataSource>(),
    ),
  );
  // serviceLocator.registerFactory(
  //   () => UserLocalRepository(
  //     userLocalDataSource: serviceLocator<UserLocalDataSource>(),
  //   ),
  // );

  serviceLocator.registerFactory(
    () =>
        UserRegisterUsecase(repository: serviceLocator<UserRemoteRepository>()),
  );
  // serviceLocator.registerFactory(
  //   () =>
  //       UserRegisterUsecase(repository: serviceLocator<UserLocalRepository>()),
  // );

  serviceLocator.registerFactory(
    () => SignupViewModel(serviceLocator<UserRegisterUsecase>()),
  );
}

Future _initHomeModule() async {
  serviceLocator.registerLazySingleton(() => HomeViewModel());
}
