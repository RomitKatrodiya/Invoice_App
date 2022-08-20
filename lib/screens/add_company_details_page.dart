import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_app_new/controllers/controller.dart';
import '../controllers/controller.dart';
import '../styles/styles.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// import 'package:shared_preferences/shared_preferences.dart';

class AddCompanyDetails extends StatelessWidget {
  AddCompanyDetails({Key? key}) : super(key: key);
  Controller controller = Get.put(Controller());

  final GlobalKey<FormState> addCompanyDetails = GlobalKey<FormState>();

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController companyAddress2Controller =
      TextEditingController();
  final TextEditingController companyAddress3Controller =
      TextEditingController();
  final TextEditingController companyGSTNoController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (controller.companyAddress.value != "") {
      companyNameController.text = controller.companyName.value;

      companyAddressController.text = controller.companyAddress.value;
      companyAddress2Controller.text = controller.companyAddress2.value;
      companyAddress3Controller.text = controller.companyAddress3.value;

      companyGSTNoController.text = controller.companyGSTNo.value;
      companyEmailController.text = controller.companyEmail.value;
      companyNumberController.text = controller.companyNumber.value;
    }

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Obx(() => Text("Company Details", style: appBarText())),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              onSave();
            },
            style: textButtonStyle(),
            child: const Text("Save"),
          ),
        ],
        backgroundColor: controller.themeColor.value,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(
                    () => CircleAvatar(
                      radius: 70,
                      backgroundColor:
                          controller.themeColor.value.withOpacity(0.2),
                      backgroundImage:
                          (controller.selectedImagePath.value == "")
                              ? null
                              : FileImage(
                                  File(controller.selectedImagePath.value),
                                ),
                      child: (controller.selectedImagePath.value != "")
                          ? const Text("")
                          : Text(
                              textAlign: TextAlign.center,
                              "Company\nLogo",
                              style: TextStyle(
                                fontSize: 20,
                                color: controller.themeColor.value,
                              ),
                            ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      imageAdd();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: controller.themeColor.value,
                      shape: const CircleBorder(),
                    ),
                    child: Obx(
                      () => Icon(
                          (controller.selectedImagePath.value.isEmpty)
                              ? Icons.add
                              : Icons.edit,
                          color: (controller.isDarkTheme.value)
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
                ],
              ),
              Form(
                key: addCompanyDetails,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text("Company Name", style: textStyleProducts()),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: controller.themeColor.value,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Company Name...";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        controller.companyName.value = val!.toString();
                      },
                      controller: companyNameController,
                      decoration: textFieldDecoration("Company Name."),
                    ),
                    const SizedBox(height: 10),
                    Text("Address Line 1", style: textStyleProducts()),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: controller.themeColor.value,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Company Address...";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        controller.companyAddress.value = val.toString();
                      },
                      controller: companyAddressController,
                      decoration:
                          textFieldDecoration("Address (Street, Building No)"),
                    ),
                    const SizedBox(height: 10),
                    Text("Address Line 2", style: textStyleProducts()),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: controller.themeColor.value,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Company Address Line 2...";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        controller.companyAddress2.value = val.toString();
                      },
                      controller: companyAddress2Controller,
                      decoration: textFieldDecoration("Address Line 2"),
                    ),
                    const SizedBox(height: 10),
                    Text("Address Line 3", style: textStyleProducts()),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: controller.themeColor.value,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Company Address Line 3...";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        controller.companyAddress3.value = val.toString();
                      },
                      controller: companyAddress3Controller,
                      decoration: textFieldDecoration("Address Line 3"),
                    ),
                    const SizedBox(height: 10),
                    Text("Tax Percentage", style: textStyleProducts()),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      hint: Text(
                        "Select Tax Percentage",
                        style: TextStyle(
                          color: controller.themeColor.value,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 5,
                          child: Text("Tax : 5%"),
                        ),
                        DropdownMenuItem(
                          value: 12,
                          child: Text("Tax : 12%"),
                        ),
                        DropdownMenuItem(
                          value: 18,
                          child: Text("Tax : 18%"),
                        ),
                        DropdownMenuItem(
                          value: 28,
                          child: Text("Tax : 28%"),
                        ),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                              color: controller.themeColor.value, width: 1.5),
                        ),
                      ),
                      validator: (val) {
                        if (controller.initialTaxValue.value == 0) {
                          return "Select Tax Percentage First...";
                        }
                        return null;
                      },
                      value: (controller.initialTaxValue.value != 0)
                          ? controller.initialTaxValue.value
                          : null,
                      onChanged: (val) {
                        controller.initialTaxValue.value = val as int;
                      },
                    ),
                    const SizedBox(height: 10),
                    Text("GST Number", style: textStyleProducts()),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: controller.themeColor.value,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Company GST No...";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        controller.companyGSTNo.value = val.toString();
                      },
                      controller: companyGSTNoController,
                      decoration: textFieldDecoration("Company GST No"),
                    ),
                    const SizedBox(height: 10),
                    Text("Phone Number", style: textStyleProducts()),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: controller.themeColor.value,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Company Phone Number...";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        controller.companyNumber.value = val.toString();
                      },
                      keyboardType: TextInputType.phone,
                      controller: companyNumberController,
                      decoration: textFieldDecoration("Company Phone Number"),
                    ),
                    const SizedBox(height: 10),
                    Text("Email Address", style: textStyleProducts()),
                    const SizedBox(height: 10),
                    TextFormField(
                      cursorColor: controller.themeColor.value,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Company Email...";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        controller.companyEmail.value = val.toString();
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: companyEmailController,
                      decoration: textFieldDecoration("Company Email"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        onSave();
                      },
                      style: elevatedButtonStyle(),
                      label: const Text("Save"),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSave() {
    if (addCompanyDetails.currentState!.validate()) {
      addCompanyDetails.currentState!.save();

      if (controller.selectedImagePath.value == "") {
        Get.snackbar(
          "Please Select Image First",
          "Tap To Select Image",
          backgroundColor: controller.themeColor.value.withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.error_outline),
          barBlur: 70,
          margin: const EdgeInsets.all(15),
          onTap: (val) {
            imageAdd();
            Get.back();
          },
        );
      } else {
        Get.back();
      }
    }
  }

  imageAdd() {
    return Get.dialog(
      AlertDialog(
        scrollable: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        title: Text(
          "When You go to pick Image ?",
          style: textStyle(),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              controller.getImage(ImageSource.gallery);
              Get.back();
            },
            style: outLinedButtonStyle(),
            child: const Text("gallery"),
          ),
          OutlinedButton(
            onPressed: () {
              controller.getImage(ImageSource.camera);
              Get.back();
            },
            style: outLinedButtonStyle(),
            child: const Text("Camera"),
          ),
        ],
      ),
    );
  }
}
