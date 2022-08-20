import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:invoice_app_new/screens/home_page.dart';
import 'package:invoice_app_new/screens/splash_screen.dart';

void main() {
  runApp(
    GetMaterialApp(
      defaultTransition: Transition.fadeIn,
      darkTheme:
          ThemeData(brightness: Brightness.dark, appBarTheme: AppBarTheme()),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}
