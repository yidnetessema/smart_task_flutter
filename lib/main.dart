import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:smart_task_frontend/theme/app_theme.dart';

import 'block/allblocproviders/getall_providers.dart';
import 'contents/account/pages/login.dart';
import 'contents/home/pages/home.dart';
import 'cubit/app_cubit_logic.dart';
import 'database/get_di.dart' as di;

void main() async {
  await di.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.allBlocProviders,
      child: GetMaterialApp(
        // title: 'Bunna Bank S.C',
        theme: AppTheme.createTheme(AppTheme.smartTaskLightTheme),
        darkTheme: AppTheme.createTheme(AppTheme.smartTaskDarkTheme),
        themeMode: ThemeMode.system,
        home: const AppCubitLogics(),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          AppCubitLogics.routeName: (context) => const AppCubitLogics()
        },
        onGenerateRoute: (settings) {
          dynamic arguments = settings.arguments;

          switch(settings.name){
            case LoginPage.routeName:
              bool autoLogin = arguments != null ? arguments['autoLogin']: false;
              return MaterialPageRoute(
                  builder: (context) => LoginPage(autoLogin: autoLogin)
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
