import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/core/network/hive_service.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:hisab_kitab/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/get_profile_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_logout_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:hisab_kitab/features/customers/data/data_source/remote_data_source/customer_remote_data_source.dart';
import 'package:hisab_kitab/features/customers/data/repository/customer_remote_repository.dart';
import 'package:hisab_kitab/features/customers/domain/repository/customer_repository.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/add_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/delete_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/update_customer_usecase.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/shops/data/data_source/remote_data_source/shop_remote_data_source.dart';
import 'package:hisab_kitab/features/shops/data/repository/shop_remote_repository.dart';
import 'package:hisab_kitab/features/shops/domain/repository/shop_repository.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/create_shop_usecase.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/get_all_shops_usecase.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/switch_shop_usecase.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:hisab_kitab/features/suppliers/data/data_source/remote_data_source/supplier_remote_data_source.dart';
import 'package:hisab_kitab/features/suppliers/data/repository/supplier_remote_repository.dart';
import 'package:hisab_kitab/features/suppliers/domain/repository/supplier_repository.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/add_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/delete_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/get_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/get_suppliers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/update_supplier_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await _initSharedPreference();
  await _initHiveService();
  await _initApiService();
  await _initSplashModule();
  await _initLoginModule();
  await _initSignupModule();
  await _initShopModule();
  await _initCustomerModule();
  await _initSupplierModule();
  await _initHomeModule();
  await _initSessionModule();
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
    () => SplashViewModel(
      serviceLocator<TokenSharedPrefs>(),
      serviceLocator<GetProfileUsecase>(),
    ),
  );
}

Future _initLoginModule() async {
  serviceLocator.registerFactory(
    () => UserLogoutUsecase(
      serviceLocator<TokenSharedPrefs>(),
      serviceLocator<UserRemoteRepository>(),
    ),
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

Future _initSessionModule() async {
  serviceLocator.registerLazySingleton(
    () => SessionCubit(switchShopUsecase: serviceLocator<SwitchShopUsecase>()),
  );
}

Future _initShopModule() async {
  // Data sources
  serviceLocator.registerFactory(
    () => ShopRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerFactory<IShopRepository>(
    () => ShopRemoteRepository(
      shopRemoteDataSource: serviceLocator<ShopRemoteDataSource>(),
    ),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => CreateShopUsecase(shopRepository: serviceLocator<IShopRepository>()),
  );
  serviceLocator.registerFactory(
    () => GetAllShopsUsecase(shopRepository: serviceLocator<IShopRepository>()),
  );
  serviceLocator.registerFactory(
    () => SwitchShopUsecase(shopRepository: serviceLocator<IShopRepository>()),
  );

  // ViewModel
  serviceLocator.registerFactory(
    () => ShopViewModel(
      createShopUsecase: serviceLocator<CreateShopUsecase>(),
      getAllShopsUsecase: serviceLocator<GetAllShopsUsecase>(),
    ),
  );
}

Future _initCustomerModule() async {
  // Data sources
  serviceLocator.registerFactory(
    () => CustomerRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerFactory<ICustomerRepository>(
    () => CustomerRemoteRepository(
      customerRemoteDataSource: serviceLocator<CustomerRemoteDataSource>(),
    ),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => AddCustomerUsecase(
      customerRepository: serviceLocator<ICustomerRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetCustomersByShopUsecase(
      customerRepository: serviceLocator<ICustomerRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetCustomerUsecase(
      customerRepository: serviceLocator<ICustomerRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UpdateCustomerUsecase(
      customerRepository: serviceLocator<ICustomerRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => DeleteCustomerUsecase(
      customerRepository: serviceLocator<ICustomerRepository>(),
    ),
  );

  // ViewModel
  // serviceLocator.registerFactory(
  //   () => CustomerViewModel(getCustomersByShopUsecase: serviceLocator<GetCustomersByShopUsecase>(), addCustomerUsecase: serviceLocator<AddCustomerUsecase>(), shopId: shopId);
  // );
}

Future _initSupplierModule() async {
  // Data sources
  serviceLocator.registerFactory(
    () => SupplierRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerFactory<ISupplierRepository>(
    () => SupplierRemoteRepository(
      supplierRemoteDataSource: serviceLocator<SupplierRemoteDataSource>(),
    ),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => AddSupplierUsecase(
      supplierRepository: serviceLocator<ISupplierRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetSuppliersByShopUsecase(
      supplierRepository: serviceLocator<ISupplierRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetSupplierUsecase(
      supplierRepository: serviceLocator<ISupplierRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UpdateSupplierUsecase(
      supplierRepository: serviceLocator<ISupplierRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => DeleteSupplierUsecase(
      supplierRepository: serviceLocator<ISupplierRepository>(),
    ),
  );

  // ViewModel
  // serviceLocator.registerFactory(
  //   () => SupplierViewModel(getSuppliersByShopUsecase: serviceLocator<GetCustomersByShopUsecase>(), addCustomerUsecase: serviceLocator<AddCustomerUsecase>(), shopId: shopId);
  // );
}
