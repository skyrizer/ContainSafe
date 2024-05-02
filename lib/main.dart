import 'package:containsafe/bloc/container/performance/performance_state.dart';
import 'package:containsafe/repository/performance_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:containsafe/pages/splashScreen.dart';
import 'package:containsafe/bloc/authentication/login/login_bloc.dart';
import 'package:containsafe/bloc/authentication/login/login_state.dart';
import 'package:containsafe/repository/auth_repo.dart';

import 'bloc/container/performance/performance_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.initialize("2c9ce8b1-a075-4864-83a3-009c8497310e");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.Notifications.addPermissionObserver((state) {
    print("Has permission " + state.toString());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = 'ContainSafe';
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(LoginInitState(), AuthRepository()),
        ),
        BlocProvider<PerformanceBloc>(
          create: (context) => PerformanceBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
            scaffoldBackgroundColor: HexColor("#ecd9c9"),
            fontFamily: 'Times New Roman',
            textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: HexColor("#3c1e08"),
                  fontSize: 13,
                ),
                bodyLarge: TextStyle(
                  color: HexColor("#3c1e08"),
                  fontSize: 23,
                )
            ),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: HexColor('#3c1e08')),
              color: HexColor('#3c1e08'),
            )
        ),
        home:Splash(),
      ),
    );
  }
}

