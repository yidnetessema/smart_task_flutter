import 'dart:async';
import 'dart:convert';

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
        body: const SizedBox());
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
