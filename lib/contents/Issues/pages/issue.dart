import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_task_frontend/contents/Issues/controllers/task_conroller.dart';
import 'package:smart_task_frontend/contents/Issues/model/TaskModel.dart';

import '../../../cubit/app_cubit_logic.dart';
import '../../../cubit/app_cubit_states.dart';
import '../../../cubit/app_cubits.dart';
import '../../../data/app_layout.dart';
import '../../../data/styles.dart';
import '../../../navigation/widgets/custom/custom_bottom_navigation.dart';
import '../../../theme/app_theme.dart';

class Issue extends StatelessWidget {
  const Issue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const InitialPage();
    return BlocProvider(
      create: (_) => AppCubits(),
      child: MaterialApp(
        title: 'Smart Home',
        home: const AppCubitLogics(),
      ),
    );
  }
}

class IssuePage extends StatefulWidget {
  const IssuePage({Key? key}) : super(key: key);
  static const routeName = '/home-screens';

  @override
  TaskBoardScreen createState() => TaskBoardScreen();
}

class TaskBoardScreen extends State<IssuePage>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;
  late TabController _tabController;

  List<int> selectedTaskPriority = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void refreshItems(
      List<int> gender, List<int> category, List<int> brand, int sortByValue) {
    setState(() {
      selectedTaskPriority = gender;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    theme = AppTheme.getTheme(context);

    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    Color backgroundColor = theme.scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Icon(Icons.arrow_back, color: theme.colorScheme.secondary),
            SizedBox(width: 8),
            Text("Tasks",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.secondary
                )
            ),
            Spacer(),
            InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      // Allows full height control
                      builder: (BuildContext buildContext) {
                        return FilterBottomSheet(
                            refreshItem:
                                (gender, category, brand, sortBy) =>
                                refreshItems(
                                    gender, category, brand, sortBy));
                      });
                },
                child: Icon(Icons.filter_list, color: Colors.grey)
            ),
            SizedBox(width: 8),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            indicator: UnderlineTabIndicator(
              borderSide:
                  BorderSide(width: 2.0, color: theme.colorScheme.primary),
              insets: const EdgeInsets.symmetric(),
            ),
            tabs: [
              Tab(text: 'Board'),
              Tab(text: 'Forms'),
              Tab(text: 'Timeline'),
              Tab(text: 'Settings'),
            ],
          ),
          if(_tabController.index == 0)...[
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TaskColumn(title: 'TO DO', count: 0,theme: theme),
                  TaskColumn(title: 'IN PROGRESS', count: 2,theme: theme),
                  TaskColumn(title: 'DONE', count: 5,theme: theme),
                ],
              ),
            ),
          ]

        ],
      ),
    );
  }
}

class TaskColumn extends StatefulWidget {
  final String title;
  final int count;
  final ThemeData theme;

  TaskColumn({required this.title, required this.count,required this.theme});

  @override
  State<TaskColumn> createState() => _TaskColumnPage();
}

class _TaskColumnPage extends State<TaskColumn> {
  late ThemeData theme;
  bool isOnAdd = false;
  TaskController taskController = TaskController();

  String? selectedTaskPriority;

  List<String> taskPriority = ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'];

  DateTime? selectedDate;

  late Future<TaskModel> tasks;

  Future<TaskModel> loadTask() async {
    // await Future.delayed(const Duration(seconds: 1));
    return await Get.find<TaskController>().getTasks(0, 10, 'ALL', 'ALL', '');
  }

  @override
  void initState() {
    super.initState();
    tasks = loadTask();
  }

  @override
  Widget build(BuildContext context) {
    theme = widget.theme;
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return SafeArea(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.50,
      margin: const EdgeInsets.only(bottom: 60, left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        // color: Colors.grey[100],
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${widget.title}  ${widget.count}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              GestureDetector(
                onTap: () {
                   setState(() {
                     isOnAdd = true;
                     taskController.actionMode = 0;
                   });
                },
                child: Icon(
                    Icons.add,
                    color: Colors.grey
                ),
              ),

            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder(
              future: !isOnAdd ?  loadTask() : Future.value(null),
              builder: (context, snapshot) {

                if(isOnAdd){
                  return createTask();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: theme.scaffoldBackgroundColor),
                      child: SpinKitThreeBounce(
                        color: theme.colorScheme.primary,
                        size: 20.0,
                      ),
                    ),
                  );
                } else  {
                  TaskModel taskModel = snapshot.data!;

                  if(taskModel.totalSize == 0){
                    return createTask();
                  }

                  return ListView.builder(
                    itemCount: taskModel.totalSize,
                    key: UniqueKey(),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    // padding: FxSpacing.fromLTRB(10, 8, 10, 10),
                    itemBuilder: (context, index) {
                      return taskWidget(taskModel.tasks[index]);
                    },
                  );
                }
              })
        ],
      ),
    ));
  }

  Widget createTask(){
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOnAdd) ...[
                    Center(
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
                          Text('Create a task to get started.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12)),
                          SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                isOnAdd = true;
                              });
                            },
                            icon: Icon(Icons.add, color: Colors.blue),
                            label: Text('Create',
                                style: TextStyle(color: Colors.blue)),
                          )
                        ],
                      ),
                    )
                  ],
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: (isOnAdd)
                          ? Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 0),
                          child: Form(
                            key: taskController.informationFormKey,
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                        color: theme
                                            .colorScheme.secondary),
                                    enabled: taskController
                                        .sendingProgressStatus ==
                                        0,
                                    controller:
                                    taskController.titleController,
                                    decoration: InputDecoration(
                                      hintText: "Task Name",
                                      hintStyle: theme
                                          .textTheme.displaySmall
                                          ?.copyWith(
                                          color: theme.colorScheme
                                              .onSecondary),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: theme.colorScheme.surface),
                                          borderRadius: BorderRadius
                                              .all(Radius.circular(
                                              AppLayout.getHeight(
                                                  10)))),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.colorScheme.surface),
                                          borderRadius: BorderRadius
                                              .all(Radius.circular(
                                              AppLayout.getHeight(
                                                  10)))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.colorScheme.surface),
                                          borderRadius: BorderRadius
                                              .all(Radius.circular(
                                              AppLayout.getHeight(
                                                  10)))),
                                      focusedErrorBorder:
                                      OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                          Styles.failureTextColor,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                          Styles.failureTextColor,
                                          width: 1,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      errorStyle: TextStyle(
                                        color: Styles.failureTextColor,
                                        fontSize: 12,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.task_outlined,
                                        size: 22,
                                        color:
                                        theme.colorScheme.onPrimary,
                                      ),
                                      isDense: true,
                                      contentPadding:
                                      const EdgeInsets.all(0),
                                    ),
                                    textCapitalization:
                                    TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Styles.primaryColor,
                                    validator:
                                    taskController.validateTitle,
                                    onChanged: (val) => {
                                      if (taskController.signUpHit)
                                        {
                                          taskController
                                              .informationFormKey
                                              .currentState!
                                              .validate()
                                        }
                                    },
                                  ),
                                  SizedBox(
                                      height: AppLayout.getHeight(20)),
                                  Container(
                                    child:
                                    DropdownButtonFormField<String>(
                                      value: selectedTaskPriority,
                                      hint: Text(
                                        'Task Priority',
                                        style: theme
                                            .textTheme.labelMedium
                                            ?.copyWith(
                                            color: theme.colorScheme
                                                .onSecondary),
                                      ),
                                      items: taskPriority
                                          .map((String priority) {
                                        return DropdownMenuItem<String>(
                                          value: priority,
                                          child: Text(
                                            priority,
                                            style: theme
                                                .textTheme.labelMedium
                                                ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .secondary),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedTaskPriority =
                                              newValue;
                                          taskController
                                              .taskPriorityController
                                              .text = newValue!;
                                        });

                                        if (taskController.signUpHit) {
                                          taskController
                                              .informationFormKey
                                              .currentState!
                                              .validate();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        prefixIcon: Icon(
                                          Icons.priority_high,
                                          color: theme
                                              .colorScheme.onPrimary,
                                        ),
                                        hintStyle: theme
                                            .textTheme.labelMedium
                                            ?.copyWith(
                                            color: theme.colorScheme
                                                .onSecondary),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                style: BorderStyle.solid,
                                                color: theme.colorScheme.surface),
                                            borderRadius: BorderRadius
                                                .all(Radius.circular(
                                                AppLayout.getHeight(
                                                    10)))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: theme.colorScheme.surface),
                                            borderRadius: BorderRadius
                                                .all(Radius.circular(
                                                AppLayout.getHeight(
                                                    10)))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: theme.colorScheme.surface),
                                            borderRadius: BorderRadius
                                                .all(Radius.circular(
                                                AppLayout.getHeight(
                                                    10)))),
                                        focusedErrorBorder:
                                        OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                            Styles.failureTextColor,
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                            Styles.failureTextColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        errorStyle: TextStyle(
                                          color:
                                          Styles.failureTextColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      dropdownColor: theme
                                          .colorScheme.primaryContainer,
                                      validator: taskController
                                          .validateTaskPriority,
                                    ),
                                  ),
                                  SizedBox(
                                      height: AppLayout.getHeight(20)),
                                  GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: taskController
                                            .dueDateController,
                                        enabled: taskController
                                            .sendingProgressStatus ==
                                            0,
                                        style: theme
                                            .textTheme.labelMedium
                                            ?.copyWith(
                                            color: theme.colorScheme
                                                .secondary),
                                        decoration: InputDecoration(
                                          hintText: "Due Date",
                                          hintStyle: theme
                                              .textTheme.displaySmall
                                              ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSecondary),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: theme.colorScheme.surface),
                                              borderRadius: BorderRadius
                                                  .all(Radius.circular(
                                                  AppLayout.getHeight(
                                                      10)))),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: theme.colorScheme.surface),
                                              borderRadius: BorderRadius
                                                  .all(Radius.circular(
                                                  AppLayout.getHeight(
                                                      10)))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: theme.colorScheme.surface),
                                              borderRadius: BorderRadius
                                                  .all(Radius.circular(
                                                  AppLayout.getHeight(
                                                      10)))),
                                          focusedErrorBorder:
                                          OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Styles
                                                  .failureTextColor,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(
                                                8),
                                          ),
                                          errorBorder:
                                          OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Styles
                                                  .failureTextColor,
                                              width: 1,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(
                                                8),
                                          ),
                                          errorStyle: TextStyle(
                                            color:
                                            Styles.failureTextColor,
                                            fontSize: 12,
                                          ),
                                          prefixIcon: Icon(
                                            Icons
                                                .calendar_today_outlined,
                                            size: 22,
                                            color: theme
                                                .colorScheme.onPrimary,
                                          ),
                                          isDense: true,
                                          contentPadding:
                                          EdgeInsets.all(0),
                                        ),
                                        validator: taskController
                                            .validateDueDate,
                                        onChanged: (val) => {
                                          if (taskController.signUpHit)
                                            {
                                              taskController
                                                  .informationFormKey
                                                  .currentState!
                                                  .validate()
                                            }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: AppLayout.getHeight(20)),
                                  TextFormField(
                                    maxLines: 5,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                        color: theme
                                            .colorScheme.secondary),
                                    enabled: taskController
                                        .sendingProgressStatus ==
                                        0,
                                    controller: taskController
                                        .descriptionController,
                                    decoration: InputDecoration(
                                      hintText: "Description",
                                      hintStyle: theme
                                          .textTheme.displaySmall
                                          ?.copyWith(
                                          color: theme.colorScheme
                                              .onSecondary),
                                      alignLabelWithHint: true,
                                      contentPadding:
                                      const EdgeInsets.only(
                                          top: 20,
                                          left: 0,
                                          right: 12,
                                          bottom: 12),
                                      // Adjusts padding inside the field
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: theme.colorScheme.surface),
                                          borderRadius: BorderRadius
                                              .all(Radius.circular(
                                              AppLayout.getHeight(
                                                  10)))),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.colorScheme.surface),
                                          borderRadius: BorderRadius
                                              .all(Radius.circular(
                                              AppLayout.getHeight(
                                                  10)))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.colorScheme.surface),
                                          borderRadius: BorderRadius
                                              .all(Radius.circular(
                                              AppLayout.getHeight(
                                                  10)))),
                                      focusedErrorBorder:
                                      OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                          Styles.failureTextColor,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                          Styles.failureTextColor,
                                          width: 1,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      errorStyle: TextStyle(
                                        color: Styles.failureTextColor,
                                        fontSize: 12,
                                      ),
                                      prefixIcon: Padding(
                                        padding:
                                        EdgeInsets.only(bottom: 85),
                                        child: Icon(
                                          Icons.description_outlined,
                                          size: 22,
                                          color: theme
                                              .colorScheme.onPrimary,
                                        ),
                                      ),
                                      isDense: true,
                                      // contentPadding:
                                      // const EdgeInsets.all(0),
                                    ),
                                    textCapitalization:
                                    TextCapitalization.sentences,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Styles.primaryColor,
                                    validator: taskController
                                        .validateDescription,
                                    onChanged: (val) => {
                                      if (taskController.signUpHit)
                                        {
                                          taskController
                                              .informationFormKey
                                              .currentState!
                                              .validate()
                                        }
                                    },
                                  ),
                                ]),
                          ))
                          : SizedBox.shrink()),
                ],
              )),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: (isOnAdd)
                  ? Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppLayout.getHeight(0),
                        vertical: AppLayout.getHeight(5)),
                    decoration: BoxDecoration(
                        color:
                        theme.colorScheme.primaryContainer),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(theme
                                  .colorScheme.onSecondary
                                  .withOpacity(0.3)),
                              padding: MaterialStateProperty.all<
                                  EdgeInsets>(
                                EdgeInsets.only(
                                    left: AppLayout.getWidth(10),
                                    right:
                                    AppLayout.getWidth(10)),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          AppLayout.getWidth(
                                              10))))),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                "Cancel",
                                style: theme
                                    .textTheme.headlineSmall!
                                    .copyWith(
                                    color: theme.colorScheme
                                        .onSecondary),
                              )
                            ],
                          ),
                          onPressed: (!taskController.isLoading)
                              ? () async {
                            setState(() {
                              isOnAdd = false;
                            });
                          }
                              : null,
                        ),
                        SizedBox(
                          width: AppLayout.getHeight(10),
                        ),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(
                                  theme.colorScheme.primary),
                              padding: MaterialStateProperty.all<
                                  EdgeInsets>(
                                EdgeInsets.only(
                                    left: AppLayout.getWidth(10),
                                    right:
                                    AppLayout.getWidth(10)),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          AppLayout.getWidth(
                                              10))))),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              (taskController.isLoading)
                                  ? SpinKitThreeBounce(
                                color:
                                Styles.whiteTextColor,
                                size: 20.0,
                              )
                                  : Text(
                                "Save",
                                style: theme.textTheme
                                    .headlineSmall!
                                    .copyWith(
                                    color:
                                    Colors.white),
                              )
                            ],
                          ),
                          onPressed: (!taskController.isLoading)
                              ? () async {
                            setState(() {
                              taskController.isLoading =
                              true;
                            });

                            bool save = await taskController
                                .registerTask(context);

                            setState(() {
                              taskController.isLoading =
                              false;

                              if (save) {
                                isOnAdd = false;
                              }
                            });

                          }
                              : null,
                        )
                      ],
                    )),
              )
                  : const SizedBox.shrink())
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: theme.colorScheme.primary,
            // Header background color
            scaffoldBackgroundColor: Colors.black,
            // Background color of the picker
            dialogBackgroundColor: Colors.black,
            // Dialog background color
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white), // General text color
              titleLarge:
                  TextStyle(color: Colors.white), // Year selection text color
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue, // Default primary color
              brightness: Theme.of(context)
                  .brightness, // Match system brightness (light/dark)
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        taskController.dueDateController.text =
            pickedDate.toString().split(' ')[0];
      });
    }
  }

  Widget taskWidget(Task task) {

    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.surface, // Border color
            width: 0.5, // Border thickness
          ),
        ),
        child: Row(
          children: [
            // Date Box
            Container(
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(12),

              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                     task.title![0],
                      // style: GoogleFonts.barlow(
                      //   fontSize: 20,
                      //   fontWeight: FontWeight.bold,
                      //   color: Colors.white,
                      // ),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 20
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Appointment Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title!,
                    // style: GoogleFonts.barlow(
                    //   fontSize: 18,
                    //   fontWeight: FontWeight.bold,
                    //   color: Colors.white,
                    // ),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.secondary
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.taskPriority!,
                    // style: GoogleFonts.barlow(
                    //   fontSize: 14,
                    //   color: Colors.white70,
                    // ),
                    style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSecondary
                    ),
                  ),

                ],
              ),
            ),

            // Video Icon
            //  Icon(
            //   Icons.more_vert,
            //   color: theme.colorScheme.onSecondary,
            // ),
            PopupMenuButton<String>(
              color: theme.colorScheme.primaryContainer,
              icon:  Icon(Icons.more_vert, color: theme.colorScheme.onSecondary),
              onSelected: (value) async {

                int id = int.parse(value.split("-")[0]);

                if(value.split("-")[1] == 'edit'){

                  Map<String, dynamic> response =  await taskController.getTaskById(id);

                      setState(() {
                        Task task = Task.fromJson(response['task']);
                        taskController.titleController.text = task.title!;
                        taskController.taskPriorityController.text = task.taskPriority!;
                        selectedTaskPriority = task.taskPriority;
                        taskController.dueDateController.text = task.dueDate!;
                        taskController.descriptionController.text = task.description!;
                        isOnAdd = true;
                        taskController.actionMode = 1;
                        taskController.id = id;
                      });
                    }else{


                      setState(()  {
                        taskController.actionMode = 2;
                      });

                      taskController.deleteTaskById(id);

                }
              },
              itemBuilder: (context) => [
                 PopupMenuItem(
                  value: "${task.id!}-edit",
                  child:  Text(
                      "Edit",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.secondary
                      ),

                  ),
                ),
                 PopupMenuItem(
                  value: "${task.id!}-delete",
                  child:  Text(
                      "Delete",
                    style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.secondary
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class FilterBottomSheet extends StatefulWidget {
  final Function(List<int>, List<int>, List<int>, int) refreshItem;

  const FilterBottomSheet({Key? key, required this.refreshItem})
      : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {

  List<String> priorityLabel = [
    'LOW',
    'MEDIUM',
    'HIGH',
    'CRITICAL'];

  List<int> priority = [0, 1, 2, 3];

  List<int> selectedGenderChoices = [];
  List<int> selectedCategoryChoices = [];
  List<int> selectedBrandChoices = [];
  String _selectedOption = '';
  int sortBy = 0;

  bool isLoadingCategory = false;
  bool isLoadingBrand = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        decoration:  BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          color: theme.colorScheme.primaryContainer
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Filter & Sort",
                      style:
                      theme.textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        color: theme.colorScheme.secondary
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: AppLayout.getHeight(8),
            ),
            Text(
              'Sort by',
              style: theme.textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: theme.colorScheme.secondary
              ),
              // style: theme.textTheme.labelMedium!
              //     .copyWith(fontWeight: FontWeight.w600, letterSpacing: 0),
            ),
            // buildRadioOption('Newest'),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildRadioOption('Newest', 0),
                  buildRadioOption('Priority: High to Low', 1),
                  buildRadioOption('Priority: Low to High', 2),
                ],
              ),
            ),
            SizedBox(
              height: AppLayout.getHeight(8),
            ),
            Text(
              'Priority',
              style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  color: theme.colorScheme.secondary
              ),
            ),
            Container(
              child: Wrap(
                children: _buildPriorityChoiceList(context),
              ),
            ),

            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(theme.colorScheme.primary),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                        horizontal: AppLayout.getWidth(15),
                        vertical: AppLayout.getHeight(12)),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(AppLayout.getWidth(10))))),
              onPressed: () {
                widget.refreshItem(selectedGenderChoices,
                    selectedCategoryChoices, selectedBrandChoices, sortBy);

                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Apply',
                    style: theme.textTheme.headlineMedium!.copyWith(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPriorityChoiceList(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> choices = [];
    priority.asMap().forEach((index, g) {
      choices.add(Container(
        padding: const EdgeInsets.all(8),
        child: ChoiceChip(
          materialTapTargetSize: MaterialTapTargetSize.padded,
          selectedColor: Colors.black,
          label: Text(
            priorityLabel[index],
            style: theme.textTheme.labelMedium!.copyWith(
                color: selectedGenderChoices.contains(g)
                    ? Colors.white
                    : Colors.black,
                fontWeight: selectedGenderChoices.contains(g)
                    ? FontWeight.w700
                    : FontWeight.w600),
          ),
          selected: selectedGenderChoices.contains(g),
          onSelected: (selected) {
            setState(() {
              selectedGenderChoices.contains(g)
                  ? selectedGenderChoices.remove(g)
                  : selectedGenderChoices.add(g);
            });
          },
        ),
      ));
    });

    return choices;
  }

  Widget buildRadioOption(String title, int index) {
    return RadioListTile<String>(
      title: Text(title,
          style: TextStyle(
            fontSize: 14,
          )),
      value: index.toString(),
      groupValue: _selectedOption,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      dense: true,
      activeColor: Colors.black,
      onChanged: (String? value) {
        setState(() {
          _selectedOption = value!;

          if (_selectedOption == '0') {
            sortBy = 0;
          } else if (_selectedOption == '1') {
            sortBy = 1;
          } else {
            sortBy = 2;
          }
        });

        widget.refreshItem(selectedGenderChoices, selectedCategoryChoices,
            selectedBrandChoices, sortBy);
      },
    );
  }

  Widget applyFilterButton(BuildContext context) {
    final theme = Theme.of(context);
    return BottomAppBar(
        height: AppLayout.getHeight(125),
        color: theme.scaffoldBackgroundColor,
        surfaceTintColor: theme.scaffoldBackgroundColor,
        child:
        BlocBuilder<AppCubits, AppCubitStates>(builder: (context, state) {
          return Container(
              child: Wrap(children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getHeight(15),
                      vertical: AppLayout.getHeight(10)),
                  child: Column(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(theme.colorScheme.primary),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: AppLayout.getWidth(15),
                                  vertical: AppLayout.getHeight(12)),
                            ),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppLayout.getWidth(10))))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Checkout',
                              style: theme.textTheme.headlineMedium!.copyWith(color: Colors.white),
                            )
                          ],
                        ),
                        onPressed: () async {
                          Map<String, dynamic> response = {};
                        },
                      )
                    ],
                  ),
                ),
              ]));
        }));
  }
}
