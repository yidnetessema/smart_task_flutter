import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


import '../../../cubit/app_cubit_states.dart';
import '../../../cubit/app_cubits.dart';
import '../../../data/app_layout.dart';
import '../../../data/styles.dart';
import '../../account/pages/login.dart';
import '../widgets/user_profile_tile.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return UserProfilePage();
  }

}

class UserProfilePage extends StatefulWidget {
  static const routeName = '/user-profile-page';
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Profile", style: theme.textTheme.headlineMedium,),
          backgroundColor: theme.scaffoldBackgroundColor,
          actions: [IconButton(onPressed: () {
            },
              icon: Icon(Icons.edit))],
          surfaceTintColor: theme.scaffoldBackgroundColor,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: BlocBuilder<AppCubits, AppCubitStates>(
                    builder: (context, state) {
                      if (state is LoadedUserState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BlocConsumer<AppCubits, AppCubitStates>(
                                        listener: (context, state) {
                                          if (state is UserNotFoundState) {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                LoginPage.routeName);
                                          }
                                        }, builder: (_, state) {
                                      if (state is LoadedUserState) {
                                        dynamic splitAvatar = state.user!['avatar']!
                                            .toString().split(',');
                                        String avatar =  splitAvatar.length > 1 ? splitAvatar[1] : splitAvatar[0];
                                        Map<dynamic, dynamic> user = state.user!;
                                        return GestureDetector(
                                          onTap: () async {


                                          },
                                          child: Container(
                                              child: Row(children: [
                                                Hero(
                                                  tag: 'profile-picture-tag',
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            AppLayout.getHeight(
                                                                50)),
                                                        image: DecorationImage(
                                                            image: Image.memory(base64Decode(avatar.isNotEmpty
                                                                ? avatar
                                                                : ''))
                                                                .image,
                                                            fit: BoxFit.cover),
                                                        color: theme.colorScheme.primary,
                                                        border: Border.all(color: Styles.darkestBackgroundColor, width: AppLayout.getHeight(1))
                                                    ),
                                                    height: AppLayout.getHeight(80),
                                                    width: AppLayout.getHeight(80),
                                                    child: Center(
                                                      child: Text(
                                                        avatar == ''
                                                            ? state
                                                            .user!['firstName']
                                                            .toString()
                                                            .substring(0, 1)
                                                            .toUpperCase()
                                                            : "",
                                                        style: theme.textTheme.titleLarge!
                                                            .copyWith(
                                                            color: theme.scaffoldBackgroundColor,
                                                            fontSize:
                                                            AppLayout
                                                                .getHeight(
                                                                40),
                                                            fontWeight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ])),
                                        );
                                      } else {
                                        return const SizedBox(
                                          height: 0,
                                        );
                                      }
                                    }),
                                    // IconButton(
                                    //     onPressed: () {
                                    //       BlocProvider.of<AppCubits>(context)
                                    //           .logoutUser(context);
                                    //     },
                                    //     icon: Icon(FluentSystemIcons
                                    //         .ic_fluent_sign_out_regular)),
                                  ],
                                ),
                                SizedBox(height: AppLayout.getHeight(5),),
                                Container(
                                  width: AppLayout.getScreenWidth() * (3/4), child: Text(overflow: TextOverflow.ellipsis, '${state.user!['firstName']} ${state.user!['lastName']}', style: theme.textTheme.headlineMedium,), alignment: Alignment.center,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppLayout.getHeight(5), vertical: AppLayout.getHeight(3)),
                                  decoration: BoxDecoration(color: theme.colorScheme.onPrimary, borderRadius: BorderRadius.circular(AppLayout.getHeight(5))),
                                  child: Text('@GC${state.user!['id']}', style: theme.textTheme.labelMedium!.copyWith(color: theme.scaffoldBackgroundColor),),),

                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: AppLayout.getHeight(15)),
                              padding: EdgeInsets.symmetric(horizontal: AppLayout.getHeight(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.surface.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(AppLayout.getHeight(10))
                                    ),
                                    child: Column(children: [
                                      getUserProfileTile(Icons.phone, state.user!['phoneNumber'], theme.colorScheme.onPrimary, '', false, () {}, context),
                                      Divider(height: 2, color: theme.colorScheme.surface,),
                                      getUserProfileTile(Icons.mail, state.user!['email'], theme.colorScheme.onPrimary, '', false, () {}, context),
                                      Divider(height: 2, color: theme.colorScheme.surface,),
                                      getUserProfileTile(Icons.cake, DateFormat("MMM dd, yyyy").format(
                                          DateTime.parse(state.user![
                                          'birthDate'])), theme.colorScheme.onPrimary, '', false, () {}, context),
                                      Divider(height: 2, color: theme.colorScheme.surface,),
                                      getUserProfileTile(state.user!['gender'] == 'M' ? Icons.male : Icons.female, state.user!['gender'] == 'F' ? "Female" : "Male", theme.colorScheme.onPrimary, '', false, () {}, context),
                                    ],),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: AppLayout.getHeight(15)),
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.surface.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(AppLayout.getHeight(10))
                                    ),
                                    child: getUserProfileTile(Icons.key, "Change Password", theme.colorScheme.onPrimary, '', true, () {

                                    }, context),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.surface.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(AppLayout.getHeight(10))
                                    ),
                                    child: getUserProfileTile(Icons.logout, "Logout", Styles.failureTextColor, 'You are logged in as ${state.user!['firstName']} ${state.user!['lastName']}', true,  () {
                                      BlocProvider.of<AppCubits>(context)
                                          .logoutUser(context);
                                    }, context),
                                  ),
                                ],),
                            ),
                          ],
                        );
                      } else if (state is UserNotFoundState) {
                        return Container(
                          height: AppLayout.getScreenHeight() / 4,
                          decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withOpacity(0.5),
                              border: Border.all(color: theme.colorScheme.surface, width: AppLayout.getHeight(1)),
                              borderRadius:
                              BorderRadius.circular(AppLayout.getHeight(10))),
                          margin: EdgeInsets.all(AppLayout.getHeight(20)),
                          padding: EdgeInsets.all(AppLayout.getHeight(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Login is required",
                                  style: theme.textTheme.headlineMedium!
                                      .copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                              Text("You need to create an account or login to see further information.",
                                style: theme.textTheme.displaySmall!
                                    .copyWith(color: theme.colorScheme.onPrimary), textAlign: TextAlign.center,),
                              SizedBox(height: AppLayout.getHeight(30),),
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(theme.colorScheme.primary),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.symmetric(
                                          vertical: AppLayout.getHeight(10)),
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
                                      "Login",
                                      style: theme.textTheme.displaySmall!.copyWith(color: theme.scaffoldBackgroundColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pushNamed(LoginPage.routeName);
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          AppLayout.getWidth(
                                              10))))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Login",
                                style: theme.textTheme.headlineSmall!.copyWith(
                                    color: theme.colorScheme.primary),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            Navigator.of(context).pushReplacementNamed(
                                LoginPage.routeName);
                          },
                        );
                      }
                    },
                  ),),
              ]),
        ));
  }
}


Future<Map<String, dynamic>> showProfilePictureChangeOptions(
    BuildContext context) async {
  final theme = Theme.of(context);
  Map<String, dynamic> response = await showModalBottomSheet(
      elevation: 0,
      barrierColor: theme.colorScheme.surface.withOpacity(0.5),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Upload profile picture",
                            style: theme.textTheme.headlineMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () => {Navigator.pop(context)},
                          child: Icon(
                            Icons.close,
                            size: AppLayout.getHeight(25),
                          ),
                        )
                      ]),
                  SizedBox(
                    height: AppLayout.getHeight(10),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: AppLayout.getHeight(5)),
                      child: Material(
                          clipBehavior: Clip.hardEdge,
                          color: theme.colorScheme.surface,
                          borderRadius:
                          BorderRadius.circular(AppLayout.getHeight(8)),
                          child: InkWell(
                              onTap: () async {

                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: AppLayout.getHeight(5)),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                          AppLayout.getHeight(10)),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                                AppLayout.getHeight(5)),
                                            decoration: BoxDecoration(
                                                color: Styles.failureTextColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        AppLayout.getHeight(
                                                            10)))),
                                            child: Icon(
                                              FluentSystemIcons
                                                  .ic_fluent_image_search_regular,
                                              color: theme.scaffoldBackgroundColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: AppLayout.getHeight(10),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "From gallary",
                                                      style: theme.textTheme.headlineSmall!
                                                          .copyWith(
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: theme.colorScheme.onPrimary,
                                                      ),
                                                    ),
                                                    Text("Get your favorite picture from gallery",
                                                        style: theme.textTheme.displaySmall),
                                                  ],
                                                ),
                                                // if (false)
                                                //   Icon(
                                                //     FluentSystemIcons
                                                //         .ic_fluent_checkmark_regular,
                                                //     color: Styles
                                                //         .successTextColor,
                                                //   )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ))))
                ],
              )),
        );
      });
  return response;
}

showProfilePicturePreviewModal(
    BuildContext context, Map<String, dynamic> request) async {
  final theme = Theme.of(context);
  bool processing = false;
  dynamic result = await showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: theme.colorScheme.surface.withOpacity(0.5),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);
            return  Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration:  BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Preview",
                          style:
                          theme.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: AppLayout.getHeight(160),
                        ),
                        Row(children: [
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: AppLayout.getHeight(5)),
                                  child: Material(
                                      clipBehavior: Clip.hardEdge,
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(
                                          AppLayout.getHeight(8)),
                                      child: InkWell(
                                          onTap: () async {
                                            Navigator.pop(context, {});
                                          },
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      AppLayout.getHeight(10)),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "Reject",
                                                        style: theme.textTheme.headlineMedium!
                                                            .copyWith(
                                                            color: theme.colorScheme.secondary),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))))),
                          SizedBox(
                            width: AppLayout.getHeight(10),
                          ),
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: AppLayout.getHeight(5)),
                                  child: Material(
                                      clipBehavior: Clip.hardEdge,
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(
                                          AppLayout.getHeight(8)),
                                      child: const SizedBox()))),
                        ]),
                      ],
                    )),
                Positioned(
                  bottom: AppLayout.getHeight(80),
                  child: CircleAvatar(
                    backgroundImage:
                    Image.memory(base64Decode(request['image'])).image,
                    minRadius: AppLayout.getHeight(50),
                    maxRadius: AppLayout.getHeight(65),
                    backgroundColor: Styles.darkTan,
                  ),
                ),
              ],
            );
          },);
      });
  return result;
}
