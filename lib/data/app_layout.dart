import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class AppLayout {
  static getTopPadding(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top;
  }

  static getBottomInset(BuildContext context) {
    return MediaQuery.of(context).viewPadding.bottom;
  }

  static getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static getScreenHeight() {
    return Get.height;
  }

  static getScreenWidth() {
    return Get.width;
  }

  static getHeight(double pixels) {
    double x = getScreenHeight()/pixels;
    return getScreenHeight()/x;
  }

  static getWidth(double pixels) {
    double x = getScreenWidth()/pixels;
    return getScreenWidth()/x;
  }
}