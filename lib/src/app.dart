import 'dart:async';

import 'package:controller/src/data/services/authentication_service.dart';
import 'package:controller/src/data/services/cloud_database_service.dart';
import 'package:controller/src/modules/authentication/authentication_view.dart';
import 'package:controller/src/modules/devices_rooms/devices_rooms_controller.dart';
import 'package:controller/src/modules/home/home_controller.dart';
import 'package:controller/src/modules/home/home_view.dart';
import 'package:controller/src/modules/settings/settings_controller.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'data/model/user_model.dart';
import 'modules/authentication/authentication_controller.dart';

class SevyController extends StatefulWidget {
  const SevyController({super.key});

  @override
  State<SevyController> createState() => _SevyControllerState();
}

class _SevyControllerState extends State<SevyController> {
  final navigatorKey = GlobalKey<NavigatorState>();

  late StreamSubscription<UserModel?> sub;

  @override
  void initState() {
    super.initState();
    sub = AuthenticationService.instance.authStateChanges().listen((event) {
      navigatorKey.currentState!.pushReplacementNamed(
        event!.email != null ? 'home' : 'authentication',
      );
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationController()),
        ChangeNotifierProvider(
          create: (_) => HomeController(),
        ),
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(create: (_) => DevicesRoomsController()),
      ],
      child: Consumer<SettingsController>(
          builder: (context, settingsController, child) {
        return FluentApp(
          debugShowCheckedModeBanner: false,
          theme: FluentThemeData(
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            accentColor: settingsController.accentColor,
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            accentColor: settingsController.accentColor,
            scaffoldBackgroundColor: Colors.black,
          ),
          themeMode: settingsController.themeMode,
          navigatorKey: navigatorKey,
          initialRoute:
              AuthenticationService.instance.firebaseAuth.currentUser == null
                  ? 'authentication'
                  : 'home',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case 'home':
                return FluentPageRoute(
                  settings: settings,
                  builder: (_) => const HomeView(),
                );
              case 'authentication':
                return FluentPageRoute(
                  settings: settings,
                  builder: (_) => const AuthenticationView(),
                );
              default:
                return FluentPageRoute(
                  settings: settings,
                  builder: (_) => Container(),
                );
            }
          },
        );
      }),
    );
  }
}
