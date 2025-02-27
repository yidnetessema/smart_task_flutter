
import 'package:flutter/material.dart';
import 'package:smart_task_frontend/theme/theme_type.dart';

class AppTheme {

  static ThemeType themeType = ThemeType.light;

  static final ColorScheme smartTaskLightTheme =
    ColorScheme.fromSeed(
      seedColor: const Color(0xff1890ff),
      primary: const Color(0xff1890ff),
      onPrimary: const Color(0xff161616),
      primaryContainer: const Color(0xfff2f2f2),
      onPrimaryContainer: const Color(0xffe73a1f),
      secondary:  Color(0xff161616),
      onSecondary: const Color(0xff808080),
      secondaryContainer: const Color(0xffe7bc91),
      onSecondaryContainer: const Color(0xff462601),
      outline: const Color(0x1F000000),
      surface: const Color(0xffffffff),
      background: const Color(0xff333333)
    );

  static final ColorScheme smartTaskDarkTheme =   ColorScheme.fromSeed(
        seedColor: Color(0xff1890ff),
        primary: Color(0xff1890ff),
        onPrimary: Color(0xff1890ff),
        primaryContainer: Color(0xff333333),
        onPrimaryContainer: Color(0xffffeeec),
        secondary: Color(0xffffffff),
        onSecondary: const Color(0xff878787),
        secondaryContainer: Color(0xff54381e),
        onSecondaryContainer: Color(0xffe7cbae),
        onBackground: Color(0xffe6e1e5),
        background: Color(0xff161616),
        outline: const Color(0xff333333),
        surface: const Color(0xffb5b5b5)

    // Match with darkTheme's scaffoldBackgroundColor
      );


  static ThemeData createTheme(ColorScheme colorScheme){

    if(themeType != ThemeType.light){
      return darkTheme.copyWith(
        colorScheme: colorScheme,
      );
    }
    return lightTheme.copyWith(
      colorScheme: colorScheme,
    );
  }


  /// -------------------------- Light Theme  -------------------------------------------- ///
  static final ThemeData lightTheme = ThemeData(

    /// Brightness
    brightness: Brightness.light,

    /// Primary Color
    primaryColor: const Color(0xff3C4EC5),

    /// Scaffold and Background color
    // scaffoldBackgroundColor: const Color(0xfff2f2f2),
    scaffoldBackgroundColor: const Color(0xffffffff),
    canvasColor: Colors.transparent,

    /// AppBar Theme
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xffffffff),
        iconTheme: IconThemeData(color: Color(0xff495057)),
        actionsIconTheme: IconThemeData(color: Color(0xff495057))),

    /// Card Theme
    cardTheme: const CardTheme(color: Color(0xfff0f0f0)),
    cardColor: const Color(0xfff0f0f0),

    /// Tab bar Theme
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Color(0xff495057),
      labelColor: Color(0xff3d63ff),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff3d63ff), width: 2.0),
      ),
    ),

    /// CheckBox theme
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(const Color(0xffeeeeee)),
      fillColor: MaterialStateProperty.all(const Color(0xff3C4EC5)),
    ),

    ///Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((state) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xffabb3ea);
        }
        return null;
      }),
      thumbColor: MaterialStateProperty.resolveWith((state) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return Color(0xff3C4EC5);
        }
        return null;
      }),
    ),
    textTheme: const TextTheme(
        titleLarge:  TextStyle(
            fontSize: 26.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500),
        labelLarge: TextStyle(
          fontSize: 18.0,
          color: Color(0xff161616),
        ),
        labelMedium:  TextStyle(
          fontSize: 14.0,
          color: Color(0xffffffff),
        ),
        labelSmall:  TextStyle(
          fontSize: 12.0,
          color: Color(0xffffffff),
        ),
        displayLarge:  TextStyle(
            fontSize: 35.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500),
        headlineLarge:  TextStyle(
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w800),
        headlineMedium:  TextStyle(
            fontSize: 18.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500),
        headlineSmall:  TextStyle(
            fontSize: 16.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500),
        displaySmall:  TextStyle(
            fontSize: 14.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500)
    ),
  );


  static final ThemeData darkTheme = ThemeData(
    /// Brightness
    brightness: Brightness.dark,

    /// Primary Color

    /// Scaffold and Background color
    scaffoldBackgroundColor: const Color(0xff161616),
    canvasColor: Colors.transparent,

    /// AppBar Theme
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xff161616)),

    /// Card Theme
    cardTheme: const CardTheme(color: Color(0xff222327)),
    cardColor: const Color(0xff222327),
    textTheme: const TextTheme(
        titleLarge:  TextStyle(
            fontSize: 26.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500),
        labelLarge:  TextStyle(
          fontSize: 18.0,
          color: Color(0xffffffff),
        ),
        labelMedium:  TextStyle(
          fontSize: 14.0,
          color: Color(0xffffffff),
        ),
        labelSmall:  TextStyle(
          fontSize: 12.0,
          color: Color(0xffffffff),
        ),
        displayLarge:  TextStyle(
            fontSize: 35.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500),
        headlineLarge:  TextStyle(
            fontSize: 24.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w800),
        headlineMedium:  TextStyle(
            fontSize: 18.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500),
        headlineSmall:  TextStyle(
            fontSize: 16.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500),
        displaySmall:  TextStyle(
            fontSize: 14.0,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w500)
    ),

  );

  static ThemeData getTheme(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    themeType = isDarkMode ? ThemeType.dark : ThemeType.light;
    return  createTheme(!isDarkMode ? smartTaskLightTheme : smartTaskDarkTheme);
  }
}