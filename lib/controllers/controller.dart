import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice_app_new/models/models.dart';
import 'package:pdf/pdf.dart';

class Controller extends GetxController {
  var pagesViewScaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    pagesViewScaffoldKey.currentState?.openDrawer();
    update();
  }

  var isDarkTheme = false.obs;

  // Product

  List<Products> productsList = <Products>[].obs;

  // Customer

  List<Customer> customersList = <Customer>[].obs;

  // Page/tab Index For NavigationBar

  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  // Color Theme
  var themeColor = Colors.blue.obs;

  // Create Invoice

  RxDouble total = 0.0.obs;
  var counter = [].obs;
  var totalList = <double>[].obs;

  // Create  PDF
  var pdfColor = PdfColors.blue.obs;
  var pdfColorLight = PdfColors.blue200.obs;

  var companyName = "".obs;
  var companyAddress = "".obs;
  var companyAddress2 = "".obs;
  var companyAddress3 = "".obs;
  var companyGSTNo = "".obs;
  var companyNumber = "".obs;
  var companyEmail = "".obs;

  var initialTaxValue = 0.obs;

  var selectedImagePath = "".obs;

  void getImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      selectedImagePath.value = pickedImage.path;
    }
  }
}
