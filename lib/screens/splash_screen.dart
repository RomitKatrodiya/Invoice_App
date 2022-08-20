import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_app_new/styles/styles.dart';

import 'home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: controller.themeColor.value.shade100,
        child: Column(
          children: [
            Spacer(),
            Icon(
              Icons.assignment_outlined,
              size: 150,
              color: controller.themeColor.value,
            ),
            Spacer(),
            CircularProgressIndicator(),
            SizedBox(
              height: 30,
            ),
            Text("Invoice Genretor"),
            Spacer(),
          ],
        ),
      ),
    ));
  }
}
