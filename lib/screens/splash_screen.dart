import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_app_new/styles/styles.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => Get.off(() => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: controller.themeColor.value.shade100,
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.assignment_outlined,
                size: 150,
                color: controller.themeColor.value,
              ),
              const Spacer(),
              CircularProgressIndicator(color: controller.themeColor.value),
              const SizedBox(height: 40),
              Text(
                "Invoice Generator",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: controller.themeColor.value,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
