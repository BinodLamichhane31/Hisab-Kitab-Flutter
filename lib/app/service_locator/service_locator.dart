import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/core/network/hive_service.dart';
import 'package:hisab_kitab/core/network/socket_service.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/assistant_bot/data/data_source/remote_datasource/assistant_remote_datasource.dart';
import 'package:hisab_kitab/features/assistant_bot/data/repository/remote_repository/assistant_remote_repository.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/repository/assistant_repository.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/use_case/ask_assistant_usecase.dart';
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
import 'package:hisab_kitab/features/dashboard/data/data_source/remote_datasource/dashboard_remote_data_source.dart';
import 'package:hisab_kitab/features/dashboard/data/repository/remote_repository/dashboard_remote_repository.dart';
import 'package:hisab_kitab/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/get_dashboard_data_usecase.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_in_usecase.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_out_usecase.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/notification/data/data_source/remote_datasource/notification_remote_data_source.dart';
import 'package:hisab_kitab/features/notification/data/repository/remote_repository/notification_remote_repository.dart';
import 'package:hisab_kitab/features/notification/domain/repository/notification_repository.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/listen_for_notifications_usecase.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/mark_all_as_read_usecase.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:hisab_kitab/features/products/data/data_source/remote_data_source/product_remote_data_source.dart';
import 'package:hisab_kitab/features/products/data/repository/product_remote_repository.dart';
import 'package:hisab_kitab/features/products/domain/repository/product_repository.dart';
import 'package:hisab_kitab/features/products/domain/use_case/add_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/delete_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/get_product_by_id_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/get_products_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/update_product_usecase.dart';
import 'package:hisab_kitab/features/purchases/data/data_source/remote_datasource/purchase_remote_data_source.dart';
import 'package:hisab_kitab/features/purchases/data/repository/remote_repository/purchase_remote_repository.dart';
import 'package:hisab_kitab/features/purchases/domain/repository/purchase_repository.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/cancel_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/create_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/get_purchase_by_id_usecase.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/get_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/record_payment_for_purchase_usecase.dart';
import 'package:hisab_kitab/features/sales/data/data_source/remote_datasource/sale_remote_data_source.dart';
import 'package:hisab_kitab/features/sales/data/repository/remote_repository/sale_remote_repository.dart';
import 'package:hisab_kitab/features/sales/domain/repository/sale_repository.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/cancel_sale_usecase.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/create_sale_usecase.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/get_sale_by_id_usecase.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/get_sales_usecase.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/record_payment_usecase.dart';
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
import 'package:hisab_kitab/features/transactions/data/data_source/remote_datasource/transaction_remote_data_source.dart';
import 'package:hisab_kitab/features/transactions/data/repository/remote_repository/transaction_remote_repository.dart';
import 'package:hisab_kitab/features/transactions/domain/repository/transaction_repository.dart';
import 'package:hisab_kitab/features/transactions/domain/use_case/get_transactions_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await _initSharedPreference();
  await _initHiveService();
  await _initApiService();
  await _initSocketService();
  await _initSplashModule();
  await _initLoginModule();
  await _initNotificationModule();
  await _initSignupModule();
  await _initShopModule();
  await _initDashboardModule();
  await _initCustomerModule();
  await _initSupplierModule();
  await _initProductModule();
  await _initSaleModule();
  await _initTransactionModule();
  await _initPurchaseModule();
  await _initHomeModule();
  await _initSessionModule();
  await _initAssistantBotModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(
    () => ApiService(Dio(), serviceLocator<TokenSharedPrefs>()),
  );
}

Future<void> _initSocketService() async {
  serviceLocator.registerLazySingleton(() => SocketService());
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

Future _initDashboardModule() async {
  // Data sources
  serviceLocator.registerFactory(
    () => DashboardRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerFactory<IDashboardRepository>(
    () => DashboardRemoteRepository(
      dashboardDataSource: serviceLocator<DashboardRemoteDataSource>(),
    ),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => GetDashboardDataUsecase(
      dashboardRepository: serviceLocator<IDashboardRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () =>
        RecordCashInUsecase(repository: serviceLocator<IDashboardRepository>()),
  );
  serviceLocator.registerFactory(
    () => RecordCashOutUsecase(
      repository: serviceLocator<IDashboardRepository>(),
    ),
  );
}

Future _initSessionModule() async {
  serviceLocator.registerLazySingleton(
    () => SessionCubit(
      switchShopUsecase: serviceLocator<SwitchShopUsecase>(),
      socketService: serviceLocator<SocketService>(),
    ),
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

Future _initProductModule() async {
  // Data sources
  serviceLocator.registerFactory(
    () => ProductRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerFactory<IProductRepository>(
    () => ProductRemoteRepository(
      productRemoteDataSource: serviceLocator<ProductRemoteDataSource>(),
    ),
  );

  // Use cases
  serviceLocator.registerFactory(
    () => AddProductUsecase(
      productRepository: serviceLocator<IProductRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetProductsUsecase(
      productRepository: serviceLocator<IProductRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetProductByIdUsecase(
      productRepository: serviceLocator<IProductRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => UpdateProductUsecase(
      productRepository: serviceLocator<IProductRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => DeleteProductUsecase(
      productRepository: serviceLocator<IProductRepository>(),
    ),
  );

  // ViewModel
  // serviceLocator.registerFactory(
  //   () => CustomerViewModel(getCustomersByShopUsecase: serviceLocator<GetCustomersByShopUsecase>(), addCustomerUsecase: serviceLocator<AddCustomerUsecase>(), shopId: shopId);
  // );
}

Future _initSaleModule() async {
  serviceLocator.registerFactory(
    () => SaleRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory<ISaleRepository>(
    () => SaleRemoteRepository(
      saleDataSource: serviceLocator<SaleRemoteDataSource>(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetSalesUsecase(saleRepository: serviceLocator<ISaleRepository>()),
  );
  serviceLocator.registerFactory(
    () => GetSaleByIdUsecase(saleRepository: serviceLocator<ISaleRepository>()),
  );
  serviceLocator.registerFactory(
    () => CancelSaleUsecase(saleRepository: serviceLocator<ISaleRepository>()),
  );
  serviceLocator.registerFactory(
    () =>
        RecordPaymentUsecase(saleRepository: serviceLocator<ISaleRepository>()),
  );
  serviceLocator.registerFactory(
    () => CreateSaleUsecase(saleRepository: serviceLocator<ISaleRepository>()),
  );
}

Future _initPurchaseModule() async {
  serviceLocator.registerFactory(
    () => PurchaseRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory<IPurchaseRepository>(
    () => PurchaseRemoteRepository(
      dataSource: serviceLocator<PurchaseRemoteDataSource>(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetPurchasesUsecase(
      purchaseRepository: serviceLocator<IPurchaseRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetPurchaseByIdUsecase(
      purchaseRepository: serviceLocator<IPurchaseRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => CancelPurchaseUsecase(
      purchaseRepository: serviceLocator<IPurchaseRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => RecordPaymentForPurchaseUsecase(
      purchaseRepository: serviceLocator<IPurchaseRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => CreatePurchaseUsecase(
      purchaseRepository: serviceLocator<IPurchaseRepository>(),
    ),
  );
}

Future _initTransactionModule() async {
  serviceLocator.registerFactory(
    () => TransactionRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory<ITransactionRepository>(
    () => TransactionRemoteRepository(
      dataSource: serviceLocator<TransactionRemoteDataSource>(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetTransactionsUsecase(
      repository: serviceLocator<ITransactionRepository>(),
    ),
  );
}

Future _initNotificationModule() async {
  serviceLocator.registerFactory(
    () => NotificationRemoteDataSource(
      apiService: serviceLocator<ApiService>(),
      socketService: serviceLocator<SocketService>(),
    ),
  );
  serviceLocator.registerFactory<INotificationRepository>(
    () => NotificationRemoteRepository(
      dataSource: serviceLocator<NotificationRemoteDataSource>(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetNotificationsUsecase(
      repository: serviceLocator<INotificationRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => MarkAllAsReadUsecase(
      repository: serviceLocator<INotificationRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => MarkAsReadUsecase(
      repository: serviceLocator<INotificationRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => ListenForNotificationsUsecase(
      repository: serviceLocator<INotificationRepository>(),
    ),
  );
}

Future _initAssistantBotModule() async {
  serviceLocator.registerFactory(
    () => AssistantRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory<IAssistantRepository>(
    () => AssistantRemoteRepository(
      dataSource: serviceLocator<AssistantRemoteDatasource>(),
    ),
  );
  serviceLocator.registerFactory(
    () =>
        AskAssistantUsecase(repository: serviceLocator<IAssistantRepository>()),
  );
}
