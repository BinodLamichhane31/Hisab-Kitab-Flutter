import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart'; // Corrected import path for clarity
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/listen_for_notifications_usecase.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/mark_all_as_read_usecase.dart';
import 'package:hisab_kitab/features/notification/domain/use_case/mark_as_read_usecase.dart'
    show MarkAllAsReadUsecase;
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_event.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart'; // <-- Add this import
import 'package:hisab_kitab/features/splash/presentation/view/splash_screen.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:hisab_kitab/app/theme/dark_theme.dart';
import 'package:hisab_kitab/app/theme/light_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<SessionCubit>()),
        BlocProvider(create: (context) => serviceLocator<ShopViewModel>()),
        BlocProvider(
          create:
              (_) => NotificationViewModel(
                getNotificationsUsecase:
                    serviceLocator<GetNotificationsUsecase>(),
                markAsReadUsecase: serviceLocator<MarkAsReadUsecase>(),
                markAllAsReadUsecase: serviceLocator<MarkAllAsReadUsecase>(),
                listenForNotificationsUsecase:
                    serviceLocator<ListenForNotificationsUsecase>(),
              )..add(LoadNotifications()),
          // Set lazy to false if you want it to start listening immediately
          // lazy: false,
        ),
      ],
      child: MaterialApp(
        title: "Hisab Kitab",
        debugShowCheckedModeBanner: false,
        theme: getLightTheme(),
        darkTheme: getDarkTheme(),
        themeMode: ThemeMode.system,
        home: BlocProvider(
          create: (context) => serviceLocator<SplashViewModel>(),
          child: const SplashScreen(),
        ),
      ),
    );
  }
}
