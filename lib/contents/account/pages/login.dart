import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_task_frontend/api/account/register.dart';
import 'package:smart_task_frontend/contents/account/controllers/login_controller.dart';
import 'package:smart_task_frontend/contents/account/pages/auth.dart';
import 'package:smart_task_frontend/cubit/app_cubit_states.dart';
import 'package:smart_task_frontend/cubit/app_cubits.dart';
import 'package:smart_task_frontend/data/app_layout.dart';
import 'package:smart_task_frontend/data/styles.dart';
import 'package:smart_task_frontend/contents/home/pages/home.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_task_frontend/data/text.dart';
import 'package:smart_task_frontend/theme/app_theme.dart';

import '../../../images/images.dart';


class LoginPage extends StatefulWidget {
  final bool autoLogin;

  const LoginPage({super.key, required this.autoLogin});

  static const routeName = '/login_screen';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late ThemeData theme;
  int currentPage = 1; //1, login; 2, verify; 3, fill information

  LoginController controller = LoginController();

  late OutlineInputBorder outlineInputBorder;

  var highLightPhone = false;
  var highLightPassword = false;

  bool loggingIn = false;
  bool resending = false;

  String otpReferenceId = "";

  Icon informationIcon = Icon(
    FluentSystemIcons.ic_fluent_info_regular,
    color: Styles.whiteTextColor,
    size: AppLayout.getHeight(15),
  );

  var informationStatus = 1; //1 information, 2 danger, 3 success
  var informationText =
      "Fill the mandatory fields to register on our mobile platform!";

  Color informationTextColor = Styles.grayTextColor;
  Color informationBackgroundColor = Styles.whiteBackground;

  String pageTitle = "Login";

  late bool finished = false;
  late bool loginUserProcessing = false;
  late String message = '';
  late int sendingProgressStatus = 0;

  final FocusNode _focusNode = FocusNode();
  bool enable = false;

  void toggle() {
    setState(() {
      enable = !enable;
    });
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

  Future<Map<String, dynamic>> resendOtp(String phoneNumber) async {
    Map<String, dynamic> response = {"status": "SUCCESS"};
    if (!resending) {
      setState(() => {resending = true});
      try {
        response = await Register().sendOtp(controller.emailController.text);

        setState(() => {resending = false});
      } catch (e) {
        setState(() => {resending = false});

        response = {
          'status': "FAILURE",
          'message': "something went wrong while trying to resend OTP!"
        };
      }
    } else {
      response = {'status': "FAILURE", 'message': "Another request exists"};
    }
    if (response['status'] == 'SUCCESS') {
      setState(() {
        informationStatus = 3;
        informationIcon = getInformationIcon(3);
        informationText = "Authorization is required";
        currentPage = 2;
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
        currentPage = 1;
      });
    }

    return response;
  }

  Future<void> autoLoginUser() async {
    // String? cp = await FlutterSecureStorage().read(key: 'cp');
    //
    // if (context.mounted) {
    //   BlocProvider.of<AppCubits>(context)
    //       .loginUser(phoneNumberController.text.trim(), cp ?? "0".trim());
    // }
  }

  @override
  void initState() {
    super.initState();

    outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(color: Colors.black12),
    );

    // Listen for focus changes and disable focus effect
    _focusNode.addListener(() {
      setState(() {});
    });

    if (widget.autoLogin) {
      autoLoginUser();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.emailController.dispose();
    controller.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    theme = AppTheme.getTheme(context);

    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    Color backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocConsumer<AppCubits, AppCubitStates>(
        listener: (context, state) {
          if (state is LoadedUserState) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                title(),
                SizedBox(height: AppLayout.getHeight(25)),
                loginForm(),
                if (state is ErrorState) ...[
                   Column(
                     children: [
                       SizedBox(height: AppLayout.getHeight(5)),
                       Row(
                         children: [
                           Icon(
                             Icons.error_outline,
                             color: Styles.failureTextColor,
                             size: 20,

                           ),
                           const SizedBox(width: 8),
                           Text(
                             "Invalid email or password!",
                             style: TextStyle(
                                 color: Styles.failureTextColor,
                                 fontSize: 14
                             ),
                           ),
                         ],
                       ),
                     ],
                   )
                ],
                forgotPassword(),
                loginBtn(state,isIOS),
                SizedBox(
                    height: AppLayout.getHeight(20)
                ),
                Row(
                  children: [
                    Expanded(child: Divider(
                      color: theme.colorScheme.outline,
                    )),
                    Padding(
                      padding: EdgeInsets.only(left: 16,right: 16),
                      child: Text(
                        'Continue with',
                         style: theme.textTheme.bodySmall?.copyWith(
                           fontSize: 10,
                           fontWeight: FontWeight.w600,
                         ),
                      ),
                    ),
                    Expanded(child: Divider(
                      color: theme.colorScheme.outline,
                    )),
                  ],
                ),
                SizedBox(
                    height: AppLayout.getHeight(20)
                ),
                continueWith(),
                SizedBox(
                    height: AppLayout.getHeight(10)
                ),
                registerBtn(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget title() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Sign In",
            style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.secondary
            ),
          ),
          SizedBox(
              height: AppLayout.getHeight(10)
          ),
          // CText.small(
          //   "Work Smarter, Achieve Faster.",
          //   fontWeight: FontWeight.w300,
          //   fontSize: 18,
          // ),
          Text(
            "Work Smarter, Achieve Faster.",
            style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.onSecondary,
                fontSize: 18
            ),
          ),
          SizedBox(
              height: AppLayout.getHeight(10)
          ),
        ],
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          emailField(),
          SizedBox(
            height: AppLayout.getHeight(20)
          ),
          passwordField()],
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.secondary
      ),
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: "Email address",
        hintStyle: theme.textTheme.displaySmall?.copyWith(
          color: theme.colorScheme.onSecondary
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Styles.failureTextColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
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
      controller: controller.emailController,
      validator: controller.validateEmail,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Styles.primaryColor,
      onChanged: (val) => {
        if (controller.signInHit) {controller.formKey.currentState!.validate()}
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.secondary
      ),
      obscureText: !enable,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.onSecondary
        ),

        border: OutlineInputBorder(
            borderSide: BorderSide(
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Styles.failureTextColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorStyle: TextStyle(
          color: Styles.failureTextColor,
          fontSize: 12,
        ),
        suffixIcon: InkWell(
            onTap: toggle,
            child: Icon(
              enable
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: theme.colorScheme.onPrimary,
            )),
        prefixIcon: Icon(
          Icons.lock_outlined,
          size: 22,
          color: theme.colorScheme.onPrimary,
        ),
        isDense: true,
        contentPadding: EdgeInsets.all(0),
      ),
      controller: controller.passwordController,
      validator: controller.validatePassword,
      keyboardType: TextInputType.text,
      cursorColor: Styles.primaryColor,
      onChanged: (val)  {
        if (controller.signInHit) {
           controller.emitWelcome(context);
          controller.formKey.currentState!.validate();

        }
      },
    );
  }

  Widget forgotPassword() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {
          controller.goToForgotPasswordScreen(context);
        },
        style: TextButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)
          ),
        ),
        child: Text(
          "Forgot password?",
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary
          ),
        ),
      ),
    );
  }

  Widget loginBtn(AppCubitStates state,bool isIOS) {
    return isIOS
       ? CupertinoButton(
      color: Styles.primaryColor,
      padding: const EdgeInsets.only(top: 12,bottom: 12),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onPressed: () async {
           controller.login(context,null, false);
         },
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             (state is LoadingState)
                 ? const SpinKitThreeBounce(
               color: Colors.white,
               size: 20.0,
             )
                 : Text(
                   "Sign In".toUpperCase(),
                   style: theme.textTheme.displayMedium?.copyWith(
                     fontWeight: FontWeight.w800,
                     color: Styles.whiteTextColor,
                   ),
               // letterSpacing: 0.5
             )
           ],
         ),
       )
       : ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(top: 12,bottom: 12),
        backgroundColor: Styles.primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)
        ),
      ),
      onPressed: () async {
        controller.login(context,null, false);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (state is LoadingState)
              ? SpinKitThreeBounce(
            color: Styles.whiteTextColor,
            size: 20.0,
          )
              : CText.small(
            "Sign In".toUpperCase(),
            fontWeight: FontWeight.w800,
            // letterSpacing: 0.5
          )
        ],
      ),
    );
  }

  Widget continueWith(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: ()  {
             signIn(0);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: theme.colorScheme.primaryContainer
            ),
            child: Image(
              height: 20,
              width: 20,
              image: AssetImage(Images.google),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            signIn(2);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: theme.colorScheme.primaryContainer
            ),
            child: Image(
              height: 20,
              width: 20,
              image: AssetImage(Images.microsoft),
            ),
          ),
        ),
        GestureDetector(
          onTap: ()  {
            signIn(1);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: theme.colorScheme.primaryContainer
            ),
            child: Image(
              height: 20,
              width: 20,
              image: AssetImage(Images.apple),
            ),
          ),
        ),
      ],
    );
  }

  Widget registerBtn() {
    return TextButton(
      onPressed: () {
        controller.goToRegisterScreen(context);
      },

      child: Text(
        "I haven't an account",
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          color: theme.colorScheme.secondary

        ),

      ),
    );
  }

  void signIn(int ssoType) async {
    User? user;
    if(ssoType == 0){
       user = await AuthMethods().signInWithGoogle();
    }else if(ssoType == 1){
      user = await AuthMethods().signInWithApple();
    }else{
      final OAuthProvider provider = OAuthProvider("microsoft.com");
      provider.setCustomParameters({"tenant":"06427fef-81f6-4eac-9d55-f5ce21221873"});

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(provider);

      user = userCredential.user;
      debugPrint("Test $user");
    }

    if (user != null) {
      controller.login(context,user,true);

    } else {
      debugPrint("Google Sign-In failed");
    }
  }

}

