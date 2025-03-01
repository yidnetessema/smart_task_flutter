import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_frontend/contents/home/pages/dashboard.dart';

import '../../../cubit/app_cubit_logic.dart';
import '../../../cubit/app_cubit_states.dart';
import '../../../cubit/app_cubits.dart';
import '../../../navigation/widgets/custom/custom_bottom_navigation.dart';
import '../../../theme/app_theme.dart';
import '../../Issues/pages/issue.dart';
import '../../setting/pages/setting.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubits(),
      child: MaterialApp(
        title: 'Smart Home',
        home: const AppCubitLogics(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home-screens';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late ThemeData theme;

  List icons = [
    FluentSystemIcons.ic_fluent_home_regular,
    Icons.folder_outlined,
    FluentSystemIcons.ic_fluent_person_regular
  ];

  final labels = ['Home', 'Projects', 'Account'];

  var currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = AppTheme.getTheme(context);

    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    Color backgroundColor = theme.scaffoldBackgroundColor;

    final screens = [const DashboardPage(), const IssuePage(), const UserProfilePage()];

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AppCubits, AppCubitStates>(
        builder: (context, state) {
          return screens[currentIndex];
        },
      ),
      bottomNavigationBar: customBottomNavigation(theme),
    );
  }

  Widget customBottomNavigation(ThemeData theme) {
    return CustomBottomNavigation(
        animationDuration: Duration(milliseconds: 350),
        selectedItemOverlayColor: theme.colorScheme.primary.withOpacity(0.15),
        backgroundColor: theme.scaffoldBackgroundColor,
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() => currentIndex = index);
        },
        items: List.generate(
            icons.length,
            (index) => CustomBottomNavigationBarItem(
                icon: Icon(icons[index]),
                activeColor: theme.colorScheme.onPrimary,
                title: labels[index],
                inactiveColor: theme.colorScheme.onPrimary.withAlpha(150))));
  }
}
