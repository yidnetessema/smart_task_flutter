import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_frontend/data/app_layout.dart';

import '../../../cubit/app_cubit_logic.dart';
import '../../../cubit/app_cubit_states.dart';
import '../../../cubit/app_cubits.dart';
import '../../../data/styles.dart';
import '../../../navigation/widgets/custom/custom_bottom_navigation.dart';
import '../../../theme/app_theme.dart';
import '../../Issues/pages/issue.dart';
import '../../setting/pages/setting.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

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

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  static const routeName = '/home-screens';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
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

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              "YT",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.qr_code, color: theme.colorScheme.secondary),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.notifications_none, color: theme.colorScheme.secondary),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<AppCubits, AppCubitStates>(
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Text(
                    'Hello Yidnekachew',
                    style: theme.textTheme.headlineLarge?.copyWith(
                       color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: AppLayout.getHeight(10)),
                  // Search Bar
                  TextField(
                    style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.secondary
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: theme.textTheme.displaySmall?.copyWith(
                          color: theme.colorScheme.onSecondary
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.colorScheme.onSecondary,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppLayout.getHeight(10)))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppLayout.getHeight(10)))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppLayout.getHeight(10)))),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Styles.failureTextColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: AppLayout.getHeight(20)),
                  // Quick Access Section
                  Text(
                    'Quick Access',
                    // style: TextStyle(
                    //   fontSize: 18.0,
                    //   fontWeight: FontWeight.bold,
                    //   color: Colors.black87,
                    // ),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    // elevation: 2.0,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(8.0),
                    // ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: theme.colorScheme.primaryContainer
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Personalise this space',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Add your most important stuff here, for fast access.',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Add your button action here
                            },
                            child: Text('Add items'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Recent Items Section
                  Text(
                    'Recent Tasks',
                    // style: TextStyle(
                    //   fontSize: 18.0,
                    //   fontWeight: FontWeight.bold,
                    //   color: Colors.black87,
                    // ),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(AppLayout.getHeight(16)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: theme.colorScheme.primaryContainer
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(FluentSystemIcons.ic_fluent_warning_regular,
                              size: 30,
                              color: theme.colorScheme.onSecondary),
                          SizedBox(height: 10),
                          Text('No tasks yet!',
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Go to projects to create task.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12)),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                  )
                  // ListTile(
                  //   leading: Icon(Icons.filter_list, color: Colors.blue),
                  //   title: Text('My open issues'),
                  //   subtitle: Text('Filter'),
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.check_circle, color: Colors.blue),
                  //   title: Text('Task 1q OM-1 - Omega'),
                  // ),
                ],
              ),
            ),
          );;
        },
      ),
    );
  }
}
