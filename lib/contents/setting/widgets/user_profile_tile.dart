import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/app_layout.dart';

Widget getUserProfileTile(IconData icon, String title, Color foregroundColor, String description, bool isClickable, Function() action, BuildContext context) {
  final theme = Theme.of(context);
  return Container(
    margin: EdgeInsets.symmetric(vertical: AppLayout.getHeight(5)),
    child: Material(
      clipBehavior: Clip.hardEdge, color: Colors.transparent,
      child: InkWell(
        onTap: isClickable ? () {
          action();
        } : null,
        child: Container(
            padding: EdgeInsets.all(AppLayout.getHeight(10)),
            child: Row(children: [
          Icon(icon, size: AppLayout.getHeight(25), color: foregroundColor,),
          SizedBox(width: AppLayout.getHeight(10),),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(overflow: TextOverflow.ellipsis, title, style: theme.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500, color: foregroundColor),),
              if(description.isNotEmpty)
              Container(width: AppLayout.getScreenWidth() * (5/6), child: Text(overflow: TextOverflow.ellipsis, description, style: theme.textTheme.displaySmall!.copyWith(color: theme.colorScheme.onPrimary)))
            ],
          ))
        ],)),
      ),
    ),
  );
}