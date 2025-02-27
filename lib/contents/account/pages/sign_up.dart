import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_frontend/cubit/app_cubits.dart';
import 'package:smart_task_frontend/data/app_layout.dart';
import 'package:smart_task_frontend/data/styles.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:smart_task_frontend/data/text.dart';
import 'package:smart_task_frontend/theme/app_theme.dart';

import '../../../cubit/app_cubit_states.dart';
import '../controllers/register_controller.dart';

void main() {
  runApp(const SignUp());
}

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Task',
      theme: AppTheme.createTheme(AppTheme.smartTaskLightTheme),
      darkTheme: AppTheme.createTheme(AppTheme.smartTaskDarkTheme),
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late ThemeData theme;

  var registering = false;

  RegisterController registerController = RegisterController();

  bool creatingAccount = false;

  List<TextEditingController> otpTextControllers = [];

  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;

  var highLightPhone = false;
  var highLightPassword = false;
  var highLightConfirmPassword = false;

  var informationStatus = 1; //1 information, 2 danger, 3 success
  var informationText =
      "Fill the mandatory fields to register on our mobile platform!";

  var otpReferenceId = "";

  Icon informationIcon = Icon(
    FluentSystemIcons.ic_fluent_info_regular,
    color: Styles.whiteTextColor,
    size: AppLayout.getHeight(15),
  );
  Color informationTextColor = Styles.grayTextColor;
  Color informationBackgroundColor = Styles.whiteBackground;

  var currentPage = 0;
  var pageTitle = "Register";

  late OutlineInputBorder outlineInputBorder;

  bool enable = false;

  String? selectedGender;

  List<String> genders = ['Male', 'Female'];
  DateTime? selectedDate;

  void toggle() {
    setState(() {
      enable = !enable;
    });
  }

  bool inputsAreValid() {
    setState(() {
      highLightPhone = false;
      highLightConfirmPassword = false;
      highLightPassword = false;
    });
    return informationStatus == 1;
  }

  Icon getInformationIcon(var status) {
    switch (status) {
      case 2:
        setState(() {
          informationTextColor = Styles.failureTextColor;
          informationBackgroundColor = Styles.failureBackgroundColor;
        });
        return Icon(
          FluentSystemIcons.ic_fluent_warning_filled,
          color: Styles.whiteTextColor,
          size: AppLayout.getHeight(15),
        );
      case 3:
        informationTextColor = Styles.successTextColor;
        informationBackgroundColor = Styles.successBackgroundColor;
        return Icon(
          FluentSystemIcons.ic_fluent_checkmark_filled,
          color: Styles.whiteTextColor,
          size: AppLayout.getHeight(15),
        );
      default:
        return Icon(
          FluentSystemIcons.ic_fluent_info_regular,
          color: Styles.whiteTextColor,
          size: AppLayout.getHeight(15),
        );
    }
  }

  Future<Map<String, dynamic>> registerUser(
      String phoneNumber, String pin) async {
    Map<String, dynamic> response = {"status": "SUCCESS"};
    if (!registering) {
      setState(() => {registering = true});
      try {
        // response = await Register()
        //     .registerUser(phoneNumberController.text, passwordController.text);

        setState(() => {registering = false});
      } catch (e) {
        setState(() => {registering = false});

        response = {
          'status': "FAILURE",
          'message': "something went wrong while trying to register user!"
        };
      }
    } else {
      response = {'status': "FAILURE", 'message': "Another request exists"};
    }
    if (response['status'] == 'SUCCESS') {
      setState(() {
        informationStatus = 3;
        informationIcon = getInformationIcon(3);
        informationText =
            "Registration was successful! Please, fill the 6 digit OTP you just received.";
        currentPage = 1;
        pageTitle = "Verification";
        otpReferenceId = response['reference_code'];
      });
    } else {
      setState(() {
        informationIcon = getInformationIcon(2);
        informationStatus = 2;
        informationText = response['message'] != null
            ? response['message'].toString()
            : "Something went wrong while trying to register user!";
      });
      currentPage = 0;
    }
    return response;
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
            primaryColor: theme.colorScheme.primary, // Header background color
            scaffoldBackgroundColor: Colors.black, // Background color of the picker
            dialogBackgroundColor: Colors.black, // Dialog background color
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white), // General text color
              titleLarge: TextStyle(color: Colors.white), // Year selection text color
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue, // Default primary color
              brightness: Theme.of(context).brightness, // Match system brightness (light/dark)
            ),
          ),
          child: child!,
        );
      },

    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        registerController.birthDateController.text =
            pickedDate.toString().split(' ')[0];
      });
    }
  }

  void _onTextChanged(String value, int index) async {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    registerController.otp =
        otpControllers.map((controller) => controller.text).join();

    if (registerController.otp.length == 6) {
      setState(() {
        registerController.isLoading = true;
      });
      await registerController.verifyEmailOtp();

      setState(() {
        registerController.signUpHit = false;
        registerController.isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    otpControllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());

    outlineInputBorder = const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Colors.black12));
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = AppTheme.getTheme(context);
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    Color backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: registerController.sendingProgressStatus != 1
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        crossAxisAlignment: registerController.sendingProgressStatus != 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          (registerController.sendingProgressStatus != 1)
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppLayout.getWidth(45),
                        height: AppLayout.getHeight(45),
                        margin: const EdgeInsets.only(top: 60, bottom: 20),
                        child: InkWell(
                          onTap: () {
                            registerController.emitWelcome(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: theme.colorScheme.primaryContainer),
                              child: const Icon(
                                  size: 24,
                                  Icons.arrow_back),
                          ),
                        ),
                      ),
                      title()
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          (registerController.sendingProgressStatus != 1)
              ? Column(
                  children: [
                    if (registerController.signUpCurrentLevel == 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocBuilder<AppCubits, AppCubitStates>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller:
                                      registerController.emailController,
                                  key: registerController.emailFieldKey,
                                  enabled: registerController
                                          .sendingProgressStatus ==
                                      0,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                      color: theme.colorScheme.secondary),
                                  decoration: InputDecoration(
                                    hintText: "Email address",
                                    hintStyle: theme.textTheme.displaySmall
                                        ?.copyWith(
                                            color:
                                                theme.colorScheme.onSecondary),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: theme.colorScheme.outline),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppLayout.getHeight(10)))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: theme.colorScheme.outline),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppLayout.getHeight(10)))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: theme.colorScheme.outline),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppLayout.getHeight(10)))),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Styles.failureTextColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Styles.failureTextColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorText: (state is ErrorState)
                                        ? state.message!
                                        : null,
                                    errorStyle: TextStyle(
                                      color: Styles.failureTextColor,
                                      fontSize: 12,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.mail_outlined,
                                      size: 22,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: Styles.primaryColor,
                                  validator: registerController.validateEmail,
                                  onChanged: (val) {
                                    if (registerController.signUpHit) {
                                      registerController
                                          .emailFieldKey.currentState!
                                          .validate();

                                      registerController.emitWelcome(context);
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      // AppLayout.getHeight(20),
                    ],

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: registerController.signUpCurrentLevel == 1
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Email verification code",
                                        // style: Styles.header2.copyWith(
                                        //     color: Styles.secondaryColor)
                                        style: theme.textTheme.labelLarge),
                                    SizedBox(height: AppLayout.getHeight(10)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(6, (index) {
                                        return SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: TextField(
                                            controller: otpControllers[index],
                                            focusNode: focusNodes[index],
                                            maxLength: 1,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            // style: const TextStyle(
                                            //   fontSize: 26,
                                            //   fontWeight: FontWeight.bold,
                                            // ),
                                            style: theme.textTheme.bodyMedium,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black)),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 0),
                                            ),
                                            onChanged: (value) =>
                                                _onTextChanged(value, index),
                                          ),
                                        );
                                      }),
                                    ),
                                    SizedBox(height: AppLayout.getHeight(5)),
                                    pasteButton()
                                  ]))
                          : const SizedBox.shrink(),
                    ),
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 700),
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.easeOut,
                        child: registerController.signUpCurrentLevel == 2
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Form(
                                  key: registerController.informationFormKey,
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
                                          enabled: registerController
                                                  .sendingProgressStatus ==
                                              0,
                                          controller: registerController
                                              .firstNameController,
                                          decoration: InputDecoration(
                                            hintText: "First Name",
                                            hintStyle: theme
                                                .textTheme.displaySmall
                                                ?.copyWith(
                                                    color: theme.colorScheme
                                                        .onSecondary),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    style: BorderStyle.solid,
                                                    color: theme
                                                        .colorScheme.outline),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppLayout.getHeight(
                                                            10)))),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: theme
                                                        .colorScheme.outline),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppLayout.getHeight(
                                                            10)))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: theme
                                                        .colorScheme.outline),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppLayout.getHeight(
                                                            10)))),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Styles.failureTextColor,
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Styles.failureTextColor,
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
                                              Icons.person_outlined,
                                              size: 22,
                                              color: theme.colorScheme.onPrimary,
                                            ),
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                          ),
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          cursorColor: Styles.primaryColor,
                                          validator: registerController
                                              .validateFirstName,
                                          onChanged: (val) => {
                                            if (registerController.signUpHit)
                                              {
                                                registerController
                                                    .informationFormKey
                                                    .currentState!
                                                    .validate()
                                              }
                                          },
                                        ),
                                        SizedBox(
                                            height: AppLayout.getHeight(20)),
                                        TextFormField(
                                          enabled: registerController
                                                  .sendingProgressStatus ==
                                              0,
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                  color: theme
                                                      .colorScheme.secondary),
                                          controller: registerController
                                              .lastNameController,
                                          decoration: InputDecoration(
                                            hintText: "Last Name",
                                            hintStyle: theme
                                                .textTheme.labelMedium
                                                ?.copyWith(
                                                    color: theme
                                                        .colorScheme.onSecondary),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    style: BorderStyle.solid,
                                                    color: theme
                                                        .colorScheme.outline),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppLayout.getHeight(
                                                            10)))),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: theme
                                                        .colorScheme.outline),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppLayout.getHeight(
                                                            10)))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: theme
                                                        .colorScheme.outline),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppLayout.getHeight(
                                                            10)))),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Styles.failureTextColor,
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Styles.failureTextColor,
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
                                              Icons.person_outlined,
                                              size: 22,
                                              color: theme.colorScheme.onPrimary,
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          cursorColor: Styles.primaryColor,
                                          validator: registerController
                                              .validateLastName,
                                          onChanged: (val) => {
                                            if (registerController.signUpHit)
                                              {
                                                registerController
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
                                            value: selectedGender,
                                            hint: Text(
                                              'Gender',
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                      color: theme.colorScheme
                                                          .onSecondary),
                                            ),
                                            items: genders.map((String gender) {
                                              return DropdownMenuItem<String>(
                                                value: gender,
                                                child: Text(
                                                  gender,
                                                  style: theme
                                                      .textTheme.labelMedium
                                                      ?.copyWith(
                                                      color: theme
                                                          .colorScheme.secondary),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedGender = newValue;
                                                registerController
                                                    .genderController
                                                    .text = newValue!;
                                              });

                                              if (registerController
                                                  .signUpHit) {
                                                registerController
                                                    .informationFormKey
                                                    .currentState!
                                                    .validate();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              prefixIcon:  Icon(
                                                  Icons.person_outlined,
                                                   color: theme.colorScheme.onPrimary,
                                              ),
                                              hintStyle: theme
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                  color: theme
                                                      .colorScheme.onSecondary),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.solid,
                                                      color: theme
                                                          .colorScheme.outline),
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          AppLayout.getHeight(
                                                              10)))),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: theme
                                                          .colorScheme.outline),
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          AppLayout.getHeight(
                                                              10)))),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: theme
                                                          .colorScheme.outline),
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
                                            ),
                                            dropdownColor: theme
                                                .colorScheme.primaryContainer,
                                            validator: registerController
                                                .validateGender,
                                          ),
                                        ),
                                        SizedBox(
                                            height: AppLayout.getHeight(20)),
                                        GestureDetector(
                                          onTap: () => _selectDate(context),
                                          child: AbsorbPointer(
                                            child: TextFormField(
                                              controller: registerController
                                                  .birthDateController,
                                              enabled: registerController
                                                      .sendingProgressStatus ==
                                                  0,
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                      color: theme.colorScheme
                                                          .secondary),
                                              decoration: InputDecoration(
                                                hintText: "Birth Date",
                                                hintStyle: theme
                                                    .textTheme.displaySmall
                                                    ?.copyWith(
                                                        color: theme.colorScheme
                                                            .onSecondary),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        style: BorderStyle.solid,
                                                        color: theme
                                                            .colorScheme.outline),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            AppLayout.getHeight(
                                                                10)))),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: theme
                                                            .colorScheme.outline),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            AppLayout.getHeight(
                                                                10)))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: theme
                                                            .colorScheme.outline),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            AppLayout.getHeight(
                                                                10)))),
                                                focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Styles.failureTextColor,
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
                                                prefixIcon: Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: 22,
                                                    color: theme.colorScheme.onPrimary,

                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                              ),
                                              validator: registerController
                                                  .validateBirthDate,
                                              onChanged: (val) => {
                                                if (registerController
                                                    .signUpHit)
                                                  {
                                                    registerController
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
                                      ]),
                                ))
                            : const SizedBox.shrink()),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: registerController.phoneFieldKey,
                          child: BlocBuilder<AppCubits, AppCubitStates>(
                            builder: (context, state) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 700),
                                      switchInCurve: Curves.easeIn,
                                      switchOutCurve: Curves.easeOut,
                                      child: registerController
                                                  .signUpCurrentLevel ==
                                              3
                                          ? IntlPhoneField(
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                            color: theme
                                                .colorScheme.secondary),
                                              controller: registerController
                                                  .phoneNumberController,
                                              autovalidateMode:
                                                  registerController.signUpHit
                                                      ? AutovalidateMode.always
                                                      : AutovalidateMode
                                                          .disabled,
                                              decoration: InputDecoration(

                                                hintText: "Phone Number",
                                                hintStyle: theme
                                                    .textTheme.displaySmall
                                                    ?.copyWith(
                                                    color: theme.colorScheme
                                                        .onSecondary),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        style: BorderStyle.solid,
                                                        color: theme
                                                            .colorScheme.outline),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            AppLayout.getHeight(
                                                                10)))),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: theme
                                                            .colorScheme.outline),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            AppLayout.getHeight(
                                                                10)))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: theme
                                                            .colorScheme.outline),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            AppLayout.getHeight(
                                                                10)))),
                                                focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Styles.failureTextColor,
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
                                                errorText: (state is ErrorState)
                                                    ? state.message!
                                                    : null,
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                              ),
                                        dropdownTextStyle: theme.textTheme.labelMedium?.copyWith(
                                          color: theme.colorScheme.secondary, // Change color of the country code text
                                        ),
                                              validator: (phone) {
                                                if (phone == null ||
                                                    phone.completeNumber
                                                        .isEmpty) {
                                                  return 'Phone number is required.';
                                                }
                                                if (phone.number.length < 9) {
                                                  return 'Enter a valid phone number.';
                                                }
                                                return null;
                                              },
                                              onChanged: (val) {
                                                if (registerController
                                                    .signUpHit) {
                                                  registerController
                                                      .phoneFieldKey
                                                      .currentState!
                                                      .validate();

                                                  registerController
                                                      .emitWelcome(context);
                                                }
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 700),
                                      switchInCurve: Curves.easeIn,
                                      switchOutCurve: Curves.easeOut,
                                      child: registerController
                                                  .signUpCurrentLevel ==
                                              4
                                          ? TextFormField(
                                              controller: registerController
                                                  .passwordController,
                                              key: registerController
                                                  .passwordFieldKey,
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                            color: theme
                                                .colorScheme.secondary),
                                              obscureText: !enable,
                                              decoration: InputDecoration(
                                                hintText: "Password",
                                                hintStyle: theme.textTheme.labelMedium
                                                    ?.copyWith(
                                                    color: theme
                                                        .colorScheme.secondary),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        style: BorderStyle.solid,
                                                        color: theme
                                                            .colorScheme.outline),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            AppLayout.getHeight(
                                                                10)))),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: theme
                                                            .colorScheme.outline),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            AppLayout.getHeight(
                                                                10)))),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: theme
                                                            .colorScheme.outline),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            AppLayout.getHeight(
                                                                10)))),
                                                focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Styles.failureTextColor,
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
                                                suffixIcon: InkWell(
                                                    onTap: toggle,
                                                    child: Icon(
                                                      enable
                                                          ? Icons
                                                              .visibility_outlined
                                                          : Icons
                                                              .visibility_off_outlined,
                                                      size: 20,
                                                      color:
                                                          theme.colorScheme.onPrimary,
                                                    )),
                                                prefixIcon: Icon(
                                                  Icons.lock_outlined,
                                                  size: 22,
                                                  color: theme.colorScheme.onPrimary,
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                              ),
                                              // validator: controller.validatePassword,
                                              keyboardType: TextInputType.text,
                                              cursorColor: Styles.primaryColor,
                                              validator: registerController
                                                  .validatePassword,
                                              onChanged: (val) => {
                                                if (registerController
                                                    .signUpHit)
                                                  {
                                                    registerController
                                                        .passwordFieldKey
                                                        .currentState!
                                                        .validate()
                                                  }
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    SizedBox(
                                        height: AppLayout.getHeight(
                                            10)), // registerBtn(),
                                    // AppLayout.getHeight(20),
                                  ]);
                            },
                          ),
                        )),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: errorWidget(),
                    // )
                  ],
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: success(),
                )
        ],
      ),
      bottomNavigationBar: (registerController.sendingProgressStatus == 0 ||
              registerController.sendingProgressStatus == 4)
          ? registerBtn()
          : const SizedBox.shrink(),
    );
  }

  Widget title() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppLayout.getHeight(10),
          Text(
            "Sign Up",
            style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.secondary),
          ),
          SizedBox(height: AppLayout.getHeight(10)),
          Text(
            "Work Smarter, Achieve Faster.",
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSecondary,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: AppLayout.getHeight(30)),
        ],
      ),
    );
  }

  Widget registerBtn() {
    return Container(
      padding: (registerController.sendingProgressStatus == 0 ||
              registerController.sendingProgressStatus == 4)
          ? const EdgeInsets.symmetric(vertical: 40, horizontal: 20)
          : EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          backgroundColor: Styles.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          if (registerController.sendingProgressStatus == 0) {
            setState(() {
              registerController.phoneFieldErrorText = "";
              registerController.isLoading = true;
            });

            await registerController.registerUser(context);

            setState(() {
              registerController.isLoading = false;
            });
          } else {
            RegisterController().goToLoginScreen(context);
          }
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          (registerController.sendingProgressStatus == 4 ||
                  registerController.isLoading)
              ? SizedBox(
                  height: AppLayout.getHeight(26),
                  child: spinKitLoading(),
                )
              : Text(
                  registerController.sendingProgressStatus == 0
                      ? (registerController.signUpCurrentLevel == 4
                          ? "SIGN UP"
                          : (registerController.signUpCurrentLevel == 1
                              ? "CONFIRM"
                              : "NEXT"))
                      : "SIGN IN",
                  style: Styles.header3.copyWith(
                      color: Styles.whiteTextColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5),
                )
        ]),
      ),
    );
  }

  Widget loginBtn() {
    return TextButton(
      style: TextButton.styleFrom(
        elevation: 0,
      ),
      onPressed: () {
        registerController.goToLoginScreen(context);
      },
      child: CText.medium("I have an account",
          fontWeight: FontWeight.bold,
          color: Styles.secondaryColor,
          decoration: TextDecoration.underline),
    );
  }

  Widget success() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: Icon(
            FluentSystemIcons.ic_fluent_checkmark_circle_regular,
            // color: Styles.successTextColor,
            color: const Color(0xFFA8E6A1),
            size: AppLayout.getHeight(80),
          ),
        ),
        SizedBox(
          height: AppLayout.getHeight(10),
        ),
        Text(
          "Let's get started.",
          // style: Styles.header1.copyWith(
          //     color: Styles.secondaryColor,
          //     fontWeight: FontWeight.w800,
          //     letterSpacing: 0.5),
          style: theme.textTheme.headlineLarge?.copyWith(
            letterSpacing: 0.5,
            fontSize: 24.0,
          ),
        ),
        SizedBox(
          height: AppLayout.getHeight(5),
        ),
        Text(
          "Your new account is ready to use.",
          // style: Styles.normalStyle.copyWith(
          //     color: Styles.grayTextColor, fontSize: 16, letterSpacing: 0.5),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSecondary
          ),
        ),
        SizedBox(height: AppLayout.getHeight(20)),
        Container(
          // margin: FxSpacing.bottom(20),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            border: Border.all(color: Styles.creamyGray),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child:  Center(
                  child: Icon(
                    Icons.person_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: AppLayout.getHeight(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${registerController.firstNameController.text} ${registerController.lastNameController.text}",
                      // style: Styles.normalStyle.copyWith(
                      //     fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5
                      ),
                    ),
                    SizedBox(height: AppLayout.getHeight(8)),
                    Row(
                      children: [
                        Text(
                          'Full Name',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSecondary
                          ),

                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppLayout.getHeight(20)),
              // Column(
              //   children: [
              //     control
              //   ],
              // ),
            ],
          ),
        ),
        SizedBox(height: AppLayout.getHeight(15)),
        Container(
          // margin: FxSpacing.bottom(20),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            border: Border.all(color: Styles.creamyGray),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child:  Center(
                  child: Icon(
                    Icons.email_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: AppLayout.getHeight(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      registerController.emailController.text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5
                  ),
                    ),
                    SizedBox(height: AppLayout.getHeight(8)),
                    Row(
                      children: [
                        Text(
                          'Email',
                          style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSecondary
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppLayout.getHeight(20)),
            ],
          ),
        ),
        SizedBox(height: AppLayout.getHeight(15)),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            border: Border.all(color: Styles.creamyGray),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child:  Center(
                  child: Icon(
                    Icons.phone_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: AppLayout.getWidth(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      registerController.phoneNumberController.text,
                      style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5
                      ),
                    ),
                    SizedBox(height: AppLayout.getHeight(8)),
                    Row(
                      children: [
                        Text(
                          'Phone Number',
                          style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSecondary
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppLayout.getHeight(20)), // Column(
              //   children: [
              //     control
              //   ],
              // ),
            ],
          ),
        ),
        SizedBox(
          height: AppLayout.getHeight(
              registerController.sendingProgressStatus == 0 ? 15 : 30),
        ),
        registerBtn()
      ],
    );
  }

  Widget pasteButton() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            // Removes default padding
            minimumSize: MaterialStateProperty.all(Size.zero),
            // Ensures no extra spacing
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces tap area
          ),
          onPressed: () async {
            ClipboardData? clipboardData =
                await Clipboard.getData(Clipboard.kTextPlain);
            if (clipboardData != null && clipboardData.text != null) {
              pasteOTP(clipboardData.text!.trim());
            }
          },
          child: Text(
            "Paste",
            // style: TextStyle(
            //     fontWeight: FontWeight.bold, color: Styles.secondaryColor),
            style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
          )),
    );
  }

  Widget spinKitLoading() {
    return SpinKitThreeBounce(
      color: Styles.whiteTextColor,
      size: 20.0,
    );
  }

  Widget errorWidget() {
    return BlocBuilder<AppCubits, AppCubitStates>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state is ErrorState) ...[
              // AppLayout.getHeight(10),
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Styles.failureTextColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.message!,
                    style:
                        TextStyle(color: Styles.failureTextColor, fontSize: 14),
                  ),
                ],
              )
            ]
          ],
        );
      },
    );
  }

  void pasteOTP(String otp) async {
    if (otp.length == 6) {
      for (int i = 0; i < 6; i++) {
        otpControllers[i].text = otp[i]; // Set each digit
      }
    }

    setState(() {
      registerController.otp =
          otpControllers.map((controller) => controller.text).join();

    });

    if (registerController.otp.length == 6) {
      setState(() {
        registerController.isLoading = true;
      });
      await registerController.verifyEmailOtp();

      setState(() {
        registerController.signUpHit = false;
        registerController.isLoading = false;
      });
    }
  }
}
