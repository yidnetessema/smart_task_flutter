import 'package:smart_task_frontend/cubit/app_cubit_states.dart';
import 'package:smart_task_frontend/contents/account/pages/login.dart';
import 'package:smart_task_frontend/contents/home/pages/home.dart';
// import 'package:hp/pages/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_cubits.dart';

class AppCubitLogics extends StatefulWidget {
  const AppCubitLogics({Key? key}) : super(key: key);
  static const routeName = '/appcubitlogics-screens';


  @override
  _AppCubitLogicsState createState() => _AppCubitLogicsState();
}

class _AppCubitLogicsState extends State<AppCubitLogics> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(body: BlocConsumer<AppCubits, AppCubitStates>(
      listener: (context, state) {
        if(state is LoadedUserState) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HomePage()));
        }
        if(state is UserNotFoundState){
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName,
              arguments: {'autoLogin': false});
        }

      },
      builder: (_, state) {
        if (state is WelcomeState) {

          BlocProvider.of<AppCubits>(context).loadUser();
        }

        if(state is LoadedUserState) {
          return const HomePage();
        } else {
          return const LoginPage(autoLogin: false);
        }
      },
    ));
  }
}
