import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';

Controller controller = Get.put(Controller());

appBarText() {
  return TextStyle(
      color: (controller.isDarkTheme.value) ? Colors.black : Colors.white);
}

textButtonStyle() {
  return TextButton.styleFrom(
    primary: (controller.isDarkTheme.value) ? Colors.black : Colors.white,
    shape: const StadiumBorder(),
    elevation: 0,
  );
}

elevatedButtonStyle() {
  return ElevatedButton.styleFrom(
    primary: controller.themeColor.value,
    onPrimary: (controller.isDarkTheme.value) ? Colors.black : Colors.white,
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  );
}

outLinedButtonStyle() {
  return OutlinedButton.styleFrom(
    primary: controller.themeColor.value,
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  );
}

textStyle() {
  return TextStyle(
    color: controller.themeColor.value,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
}

textStyleProducts() {
  return TextStyle(
    color: controller.themeColor.value,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );
}

textFieldDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    alignLabelWithHint: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: controller.themeColor.value, width: 1.5),
      borderRadius: BorderRadius.circular(50),
    ),
    hintStyle: TextStyle(
      color: controller.themeColor.value,
    ),
  );
}
