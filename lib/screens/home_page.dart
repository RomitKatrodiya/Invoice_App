import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_app_new/screens/create_invoice_page.dart';

import '../controllers/controller.dart';

import '../models/models.dart';
import '../styles/styles.dart';
import 'add_company_details_page.dart';
import 'package:pdf/pdf.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  Controller controller = Get.put(Controller());

  final GlobalKey<FormState> addProduct = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();

  final GlobalKey<FormState> addCustomer = GlobalKey<FormState>();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerNumberController =
      TextEditingController();

  String? productName;
  String? price;
  String? customerName;
  String? customerNumber;

  List<Map> themeColors = [
    {
      "name": "Blue",
      "color": Colors.blue,
      "pdfColor": PdfColors.blue,
      "pdfColorLight": PdfColors.blue100,
    },
    {
      "name": "Green",
      "color": Colors.green,
      "pdfColor": PdfColors.green,
      "pdfColorLight": PdfColors.green100,
    },
    {
      "name": "Orange",
      "color": Colors.orange,
      "pdfColor": PdfColors.orange,
      "pdfColorLight": PdfColors.orange100,
    },
    {
      "name": "Purple",
      "color": Colors.purple,
      "pdfColor": PdfColors.purple,
      "pdfColorLight": PdfColors.purple100,
    },
    {
      "name": "Teal",
      "color": Colors.teal,
      "pdfColor": PdfColors.teal,
      "pdfColorLight": PdfColors.teal100,
    },
    {
      "name": "Pink",
      "color": Colors.pink,
      "pdfColor": PdfColors.pink,
      "pdfColorLight": PdfColors.pink100,
    },
    {
      "name": "Red",
      "color": Colors.red,
      "pdfColor": PdfColors.red,
      "pdfColorLight": PdfColors.red100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Get.dialog(
          AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            scrollable: true,
            title: Center(
              child: Text("Exit From App", style: textStyle()),
            ),
            content:
                Text("Are you sure want to exit?", style: textStyleProducts()),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: elevatedButtonStyle(),
                child: const Text("Yes"),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: outLinedButtonStyle(),
                child: const Text("No"),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        key: controller.pagesViewScaffoldKey,
        drawer: drawer(controller, themeColors),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.openDrawer();
            },
            icon: Obx(() => Icon(Icons.dehaze,
                color: (controller.isDarkTheme.value)
                    ? Colors.black
                    : Colors.white)),
          ),
          title: Obx(
            () => (controller.tabIndex.value == 0)
                ? Text("Products", style: appBarText())
                : Text("Customers", style: appBarText()),
          ),
          actions: [
            Obx(
              () => TextButton(
                onPressed: () {
                  if (controller.companyName.value == "") {
                    controller.openDrawer();
                    Get.snackbar(
                      "Please Enter Company Details",
                      "Tap To Enter Details",
                      backgroundColor:
                          controller.themeColor.value.withOpacity(0.7),
                      snackPosition: SnackPosition.BOTTOM,
                      icon: const Icon(Icons.error_outline),
                      barBlur: 70,
                      margin: const EdgeInsets.all(15),
                      onTap: (val) {
                        Get.to(AddCompanyDetails());
                        Get.back();
                      },
                    );
                  } else if (controller.productsList.isEmpty) {
                    controller.tabIndex.value = 0;
                    Get.snackbar(
                      "Please Add Product",
                      "Tap To Add Product",
                      backgroundColor:
                          controller.themeColor.value.withOpacity(0.7),
                      snackPosition: SnackPosition.BOTTOM,
                      icon: const Icon(Icons.error_outline),
                      barBlur: 70,
                      margin: const EdgeInsets.all(15),
                      onTap: (val) {
                        addEditDialogBox(controller, "");
                        Get.back();
                      },
                    );
                  } else if (controller.customersList.isEmpty) {
                    controller.tabIndex.value = 1;
                    Get.snackbar(
                      "Please Add Customer",
                      "Tap To Add Customer",
                      backgroundColor:
                          controller.themeColor.value.withOpacity(0.7),
                      snackPosition: SnackPosition.BOTTOM,
                      icon: const Icon(Icons.error_outline),
                      barBlur: 70,
                      margin: const EdgeInsets.all(15),
                      onTap: (val) {
                        addEditDialogBox(controller, "");
                        Get.back();
                      },
                    );
                  } else {
                    Get.to(const CreateInvoice());
                  }
                },
                style: textButtonStyle(),
                child: const Text(
                  "Create\nInvoice",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
          centerTitle: true,
          backgroundColor: controller.themeColor.value,
        ),
        body: homePage(controller),
        floatingActionButton: Obx(() => (controller.tabIndex.value == 0)
            ? ElevatedButton.icon(
                onPressed: () {
                  addEditDialogBox(controller, "");
                },
                label: const Text("Product"),
                icon: const Icon(Icons.add_shopping_cart),
                style: elevatedButtonStyle(),
              )
            : ElevatedButton.icon(
                onPressed: () {
                  addEditDialogBox(controller, "");
                },
                label: const Text("Customer"),
                icon: const Icon(Icons.person_add_rounded),
                style: elevatedButtonStyle(),
              )),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            unselectedItemColor: (controller.isDarkTheme.value)
                ? controller.themeColor.value.shade100
                : Colors.black45,
            selectedItemColor: (controller.isDarkTheme.value)
                ? controller.themeColor.value.shade400
                : controller.themeColor.value.shade600,
            backgroundColor: controller.themeColor.value.withOpacity(0.15),
            onTap: (value) => controller.tabIndex.value = value,
            currentIndex: controller.tabIndex.value,
            elevation: 0,
            iconSize: 32,
            unselectedFontSize: 13,
            selectedFontSize: 16,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.shopping_cart),
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.people_alt),
                icon: Icon(Icons.people_alt_outlined),
                label: 'Customers',
              ),
            ],
          ),
        ),
      ),
    );
  }

  homePage(controller) {
    return Obx(
      () => (controller.tabIndex.value == 0
              ? controller.productsList.isEmpty
              : controller.customersList.isEmpty)
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    (controller.tabIndex.value == 0)
                        ? Icons.production_quantity_limits
                        : Icons.people_alt,
                    color: controller.themeColor.value.withOpacity(0.7),
                    size: 70,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    (controller.tabIndex.value == 0)
                        ? "You don't have any Products"
                        : "You don't have any customers",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: controller.themeColor.value.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: (controller.tabIndex.value == 0)
                  ? controller.productsList.length
                  : controller.customersList.length,
              itemBuilder: (context, i) {
                return Card(
                  margin: const EdgeInsets.only(top: 8),
                  shape: const StadiumBorder(),
                  color: controller.themeColor.value.withOpacity(0.15),
                  elevation: 0,
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${i + 1}",
                          style: textStyleProducts(),
                        ),
                      ],
                    ),
                    title: Text(
                      (controller.tabIndex.value == 0)
                          ? "Name  :  ${controller.productsList[i].productName}"
                          : "Name  :  ${controller.customersList[i].customerName}",
                      style: textStyleProducts(),
                    ),
                    subtitle: Text(
                      (controller.tabIndex.value == 0)
                          ? "Price  :  ${controller.productsList[i].price}"
                          : "Number  :  ${controller.customersList[i].customerNumber}",
                      style: textStyleProducts(),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: (controller.tabIndex.value == 0)
                                ? "Edit Product"
                                : "Edit Customer",
                            onPressed: () {
                              addEditDialogBox(controller, i);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: controller.themeColor.value,
                            ),
                          ),
                          IconButton(
                            tooltip: (controller.tabIndex.value == 0)
                                ? "Delete Product"
                                : "Delete Customer",
                            onPressed: () {
                              (controller.tabIndex.value == 0)
                                  ? controller.productsList
                                      .remove(controller.productsList[i])
                                  : controller.customersList
                                      .remove(controller.customersList[i]);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: controller.themeColor.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  addEditDialogBox(controller, i) {
    if (i == "") {
      productPriceController.clear();
      productNameController.clear();
      customerNameController.clear();
      customerNumberController.clear();
      productName = "";
      price = "";
      customerName = "";
      customerNumber = "";
    } else {
      if (controller.tabIndex.value == 0) {
        productNameController.text = controller.productsList[i].productName;
        productPriceController.text = controller.productsList[i].price;
      } else {
        customerNameController.text = controller.customersList[i].customerName;
        customerNumberController.text =
            controller.customersList[i].customerNumber;
      }
    }
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        scrollable: true,
        title: Text(
          (controller.tabIndex.value == 0)
              ? 'Product Details'
              : "Customer Details",
          textAlign: TextAlign.center,
          style: textStyle(),
        ),
        content: Form(
          key: (controller.tabIndex.value == 0) ? addProduct : addCustomer,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                cursorColor: controller.themeColor.value,
                validator: (val) {
                  if (val!.isEmpty) {
                    return (controller.tabIndex.value == 0)
                        ? "Enter Product Name..."
                        : "Enter Customer Name...";
                  }
                  return null;
                },
                onSaved: (val) {
                  (controller.tabIndex.value == 0)
                      ? productName = val
                      : customerName = val;
                },
                controller: (controller.tabIndex.value == 0)
                    ? productNameController
                    : customerNameController,
                decoration: textFieldDecoration((controller.tabIndex.value == 0)
                    ? "Product Name"
                    : "Customer Name"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                cursorColor: controller.themeColor.value,
                validator: (val) {
                  if (val!.isEmpty) {
                    return (controller.tabIndex.value == 0)
                        ? "Enter Product Price..."
                        : "Enter Customer Number...";
                  }
                  return null;
                },
                onSaved: (val) {
                  (controller.tabIndex.value == 0)
                      ? price = val
                      : customerNumber = val;
                },
                keyboardType: TextInputType.number,
                controller: (controller.tabIndex.value == 0)
                    ? productPriceController
                    : customerNumberController,
                decoration: textFieldDecoration((controller.tabIndex.value == 0)
                    ? "Product Price"
                    : "Customer Number"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if ((controller.tabIndex.value == 0)
                      ? addProduct.currentState!.validate()
                      : addCustomer.currentState!.validate()) {
                    (controller.tabIndex.value == 0)
                        ? addProduct.currentState!.save()
                        : addCustomer.currentState!.save();

                    if (controller.tabIndex.value == 0) {
                      Products p = Products.fromAdd(
                        productName: productName.toString(),
                        price: price.toString(),
                      );
                      (i == "")
                          ? controller.productsList.add(p)
                          : controller.productsList[i] = p;
                    } else {
                      Customer c = Customer.fromAdd(
                        customerName: customerName.toString(),
                        customerNumber: customerNumber.toString(),
                      );
                      (i == "")
                          ? controller.customersList.add(c)
                          : controller.customersList[i] = c;
                    }
                    Get.back();
                  }
                },
                style: elevatedButtonStyle(),
                child: Text((i == "")
                    ? (controller.tabIndex.value == 0)
                        ? "Add Products"
                        : "Add Customer"
                    : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  drawer(companyDetails, List themeColors) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          // bottomRight: Radius.circular(20),
          topRight: Radius.circular(50),
        ),
      ),
      child: Obx(
        () => Container(
          child: (companyDetails.companyName == "")
              ? Column(
                  children: [
                    const Spacer(flex: 5),
                    Icon(
                      Icons.info_outline,
                      color: controller.themeColor.value.withOpacity(0.7),
                      size: 50,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "ADD\nCompany Details",
                      style: textStyle(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_business_outlined),
                      label: const Text("ADD   "),
                      onPressed: () {
                        Get.to(() => AddCompanyDetails());
                      },
                      style: elevatedButtonStyle(),
                    ),
                    const Spacer(flex: 4),
                    InkWell(
                      onTap: () {
                        themeDialog(themeColors);
                      },
                      child: drawerItems(
                          Icons.color_lens_sharp, "Change Theme Color"),
                    ),
                    darkMode(),
                    const Spacer(),
                  ],
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        height: 210,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: controller.themeColor.value,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Spacer(),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  controller.themeColor.value.shade200,
                              backgroundImage: FileImage(
                                File(companyDetails.selectedImagePath.value),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${companyDetails.companyName}",
                              style: TextStyle(
                                  color: (controller.isDarkTheme.value)
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(AddCompanyDetails());
                        },
                        child: drawerItems(Icons.edit, "Edit Company Details"),
                      ),
                      InkWell(
                        onTap: () {
                          themeDialog(themeColors);
                        },
                        child: drawerItems(
                            Icons.color_lens_sharp, "Change Theme Color"),
                      ),
                      darkMode(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  darkMode() {
    return ListTile(
      onTap: () {
        controller.isDarkTheme.value = !controller.isDarkTheme.value;
        (controller.isDarkTheme.value)
            ? Get.changeTheme(ThemeData.dark())
            : Get.changeTheme(ThemeData.light());
      },
      title: Text(
        "Dark Mode",
        style: TextStyle(
          fontSize: 15,
          color: (controller.isDarkTheme.value)
              ? controller.themeColor.value
              : Colors.grey.shade700,
        ),
      ),
      leading: Icon(
        Icons.dark_mode_rounded,
        size: 24,
        color: (controller.isDarkTheme.value)
            ? controller.themeColor.value
            : Colors.grey.shade700,
      ),
      shape: Border(
        bottom: BorderSide(color: controller.themeColor.value.shade500),
      ),
      trailing: Switch(
        activeColor: controller.themeColor.value,
        value: controller.isDarkTheme.value,
        onChanged: (val) {
          (val)
              ? Get.changeTheme(ThemeData.dark())
              : Get.changeTheme(ThemeData.light());
          controller.isDarkTheme.value = val;
        },
      ),
    );
  }

  drawerItems(icon, name) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          fontSize: 15,
          color: (controller.isDarkTheme.value)
              ? controller.themeColor.value
              : Colors.grey.shade700,
        ),
      ),
      leading: Icon(
        icon,
        size: 24,
        color: (controller.isDarkTheme.value)
            ? controller.themeColor.value
            : Colors.grey.shade700,
      ),
      shape: Border(
        bottom: BorderSide(color: controller.themeColor.value.shade500),
      ),
    );
  }

  themeDialog(List themeColors) {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        scrollable: true,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Select Theme Color',
            style: textStyle(),
          ),
        ),
        content: Column(
            children: themeColors
                .map(
                  (e) => InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      controller.themeColor.value = e["color"];
                      controller.pdfColor.value = e["pdfColor"] as PdfColor;
                      controller.pdfColorLight.value =
                          e["pdfColorLight"] as PdfColor;
                      Get.offAll(() => HomePage());
                      controller.openDrawer();
                    },
                    child: Card(
                      shape: StadiumBorder(
                        side: BorderSide(color: controller.themeColor.value),
                      ),
                      elevation: 0,
                      color: controller.themeColor.value.withOpacity(0.07),
                      child: ListTile(
                        leading: Icon(
                          Icons.color_lens_sharp,
                          color: e["color"],
                          size: 35,
                        ),
                        title: Text(e["name"],
                            style: TextStyle(
                              color: e["color"],
                              fontSize: 18,
                            )),
                      ),
                    ),
                  ),
                )
                .toList()),
      ),
    );
  }
}
