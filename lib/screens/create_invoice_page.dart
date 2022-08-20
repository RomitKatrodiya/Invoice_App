import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_app_new/screens/home_page.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import '../styles/styles.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class CreateInvoice extends StatelessWidget {
  const CreateInvoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.total.value = 0;
    controller.counter.value = [];
    controller.totalList.value = [];

    for (int i = 0; i < controller.productsList.length; i++) {
      controller.counter.add(0);
      controller.totalList.add(0.0);
    }
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("Select Products", style: appBarText())),
        centerTitle: true,
        backgroundColor: controller.themeColor.value,
        leading: IconButton(
            tooltip: "Back To Home Page",
            icon: Obx(
              () => Icon(
                Icons.arrow_back_ios_new_sharp,
                color: (controller.isDarkTheme.value)
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            onPressed: () {
              Get.back();
            }),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 12,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: controller.productsList.length,
              itemBuilder: (context, i) {
                return Card(
                  margin: const EdgeInsets.only(top: 8),
                  shape: const StadiumBorder(),
                  color: controller.themeColor.value.withOpacity(0.2),
                  elevation: 0,
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "  ${i + 1}",
                          style: textStyleProducts(),
                        ),
                      ],
                    ),
                    title: Text(
                      "${controller.productsList[i].productName}",
                      style: textStyleProducts(),
                    ),
                    subtitle: Text(
                      " ₹ ${controller.productsList[i].price}",
                      style: textStyleProducts(),
                    ),
                    trailing: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            splashColor:
                                controller.themeColor.value.withOpacity(0.4),
                            onPressed: () {
                              (controller.counter[i] == 0)
                                  ? controller.counter[i] = 0
                                  : controller.counter[i] =
                                      controller.counter[i] - 1;
                              controller.totalList[i] = controller.counter[i] *
                                  double.parse(
                                      "${controller.productsList[i].price}");
                              controller.total.value = 0;

                              // ignore: avoid_function_literals_in_foreach_calls
                              controller.totalList.forEach((element) {
                                controller.total.value =
                                    controller.total.value + element;
                              });
                            },
                            icon: Icon(Icons.minimize,
                                size: 30, color: controller.themeColor.value),
                          ),
                          Obx(
                            () => Text(
                              "${controller.counter[i]}",
                              style: textStyle(),
                            ),
                          ),
                          IconButton(
                            splashColor:
                                controller.themeColor.value.withOpacity(0.4),
                            onPressed: () {
                              controller.counter[i] = controller.counter[i] + 1;
                              controller.totalList[i] = controller.counter[i] *
                                  double.parse(
                                      "${controller.productsList[i].price}");
                              controller.total.value = 0;

                              controller.total.value =
                                  controller.totalList.fold(0, (p, e) => p + e);
                            },
                            icon: Icon(
                              Icons.add,
                              size: 30,
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
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: controller.themeColor.value.withOpacity(0.2),
              child: Row(
                children: [
                  const Spacer(flex: 4),
                  Obx(
                    () => Text(
                      "Total = ₹ ${controller.total.value}",
                      style: textStyle(),
                    ),
                  ),
                  const Spacer(flex: 4),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (controller.total.value == 0) {
                        Get.snackbar(
                          "Select Products First",
                          "After Next Button is Working....",
                          backgroundColor:
                              controller.themeColor.value.withOpacity(0.7),
                          snackPosition: SnackPosition.BOTTOM,
                          icon: const Icon(Icons.error_outline_outlined),
                          barBlur: 70,
                          margin: const EdgeInsets.all(15),
                        );
                      } else {
                        Get.dialog(
                          AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            scrollable: true,
                            title: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Select Customer',
                                style: textStyle(),
                              ),
                            ),
                            content: Column(
                              children: controller.customersList
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {
                                        Get.back();
                                        pdfDialogBox(e);
                                      },
                                      borderRadius: BorderRadius.circular(50),
                                      child: Card(
                                        shape: const StadiumBorder(),
                                        color: controller.themeColor.value
                                            .withOpacity(0.2),
                                        elevation: 0,
                                        child: ListTile(
                                          title: Text(
                                            "${e.customerName}",
                                            style: textStyleProducts(),
                                          ),
                                          trailing: Text(
                                            "${e.customerNumber}",
                                            style: textStyleProducts(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      }
                    },
                    style: elevatedButtonStyle(),
                    label: const Text("Next"),
                    icon:
                        const Icon(Icons.keyboard_double_arrow_right_outlined),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

pdfDialogBox(e) {
  DateTime dateToday = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second,
    DateTime.now().millisecond,
  );
  DateTime dueToday = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day + 30,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second,
    DateTime.now().millisecond,
  );
  final pdf = pw.Document();
  createPDF(e, dateToday, dueToday, pdf);
  Get.dialog(
    AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      scrollable: true,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          'PDF Tools',
          style: textStyle(),
        ),
      ),
      content: Column(
        children: [
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              Directory? dir = await getApplicationDocumentsDirectory();

              File file = File("${dir.path}/${e.customerName}$dateToday.pdf");

              await file.writeAsBytes(await pdf.save());
              Get.snackbar(
                "PDF Save Successfully...",
                "Tap To Open PDF",
                backgroundColor: controller.themeColor.value.withOpacity(0.7),
                snackPosition: SnackPosition.BOTTOM,
                icon: const Icon(Icons.download_done_outlined),
                barBlur: 70,
                margin: const EdgeInsets.all(15),
                onTap: (val) async {
                  await OpenFile.open(file.path);
                },
              );
            },
            label: const Text("Save Invoice PDF"),
            icon: const Icon(Icons.save_alt),
            style: elevatedButtonStyle(),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              Directory? dir = await getExternalStorageDirectory();
              // Directory? dir = await getApplicationDocumentsDirectory();

              File file = File("${dir!.path}/${e.customerName}$dateToday.pdf");

              await file.writeAsBytes(await pdf.save());

              await OpenFile.open(file.path);
            },
            label: const Text("Open Invoice PDF"),
            icon: const Icon(Icons.file_open_outlined),
            style: elevatedButtonStyle(),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              Uint8List bytes = await pdf.save();

              await Printing.layoutPdf(onLayout: (format) => bytes);
            },
            label: const Text("Print Invoice PDF"),
            icon: const Icon(Icons.local_printshop_outlined),
            style: elevatedButtonStyle(),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              Directory? dir = await getExternalStorageDirectory();

              File file = File("${dir!.path}/${e.customerName}$dateToday.pdf");

              var sharePdf = await file.writeAsBytes(await pdf.save());

              Share.shareFiles([(sharePdf.path)]);
            },
            label: const Text("Share Invoice PDF"),
            icon: const Icon(Icons.share_rounded),
            style: elevatedButtonStyle(),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () async {
              Get.offAll(HomePage());
            },
            label: const Text("Home Page"),
            icon: const Icon(Icons.home),
            style: TextButton.styleFrom(
              primary: controller.themeColor.value,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
          ),
        ],
      ),
    ),
  );
}

createPDF(e, dateToday, dueToday, pdf) {
  List showProducts = [];
  List showTotalList = [];
  List<int> showCounter = [];
  double newTotal = 0;
  List showTax = [];

  List indexList = [];
  int index = 0;
  int totalCount = 0;
  num totalTax = 0;

  for (int i = 0; i < controller.totalList.length; i++) {
    if (controller.counter[i] != 0) {
      showProducts.add(controller.productsList[i]);
      showTax.add(controller.totalList[i] *
          controller.initialTaxValue.toDouble() /
          100);
      showTotalList.add(controller.totalList[i] *
              controller.initialTaxValue.toDouble() /
              100 +
          controller.totalList[i]);
      showCounter.add(controller.counter[i]);
      indexList.add(index++);
    }
  }

  newTotal = showTotalList.fold(0, (p, c) => p + c);
  totalCount = showCounter.fold(0, (p, c) => p + c);
  totalTax = showTax.fold(0, (p, c) => p + c);

  var pdfColor2 = PdfColors.grey;
  var pdfColor3 = PdfColors.black;

  var style1 = pw.TextStyle(
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.black,
  );
  var style2 = const pw.TextStyle(
    fontSize: 12,
    color: PdfColors.grey,
  );
  final image = pw.MemoryImage(
    File(controller.selectedImagePath.value).readAsBytesSync(),
  );

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text(
          "INVOICE",
          style: pw.TextStyle(
            fontSize: 15,
            color: pdfColor2,
          ),
        ),
        pw.Divider(color: pdfColor2),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Container(
              height: 50,
              width: 50,
              child: pw.ClipRRect(
                horizontalRadius: 25,
                verticalRadius: 25,
                child: pw.Image(image, fit: pw.BoxFit.cover),
              ),
            ),
            pw.Spacer(),
            pw.Column(
              children: [
                pw.Text(
                  "${controller.companyName}",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: controller.pdfColor.value,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  "${controller.companyName}, ${controller.companyAddress}, ${controller.companyAddress2}, ${controller.companyAddress3}.",
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: pdfColor2,
                  ),
                ),
              ],
            ),
            pw.Spacer(),
            pw.Container(
              height: 50,
              width: 50,
              child: pw.ClipRRect(
                horizontalRadius: 25,
                verticalRadius: 25,
                child: pw.Image(image, fit: pw.BoxFit.cover),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Divider(color: pdfColor2),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 5),
                  pw.Text("BILL TO", style: style1),
                  pw.SizedBox(height: 2),
                  pw.Text(e.customerName, style: style2),
                  pw.SizedBox(height: 2),
                  pw.Text(e.customerNumber, style: style2),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 5),
                  pw.Text("Issue Date and Time", style: style1),
                  pw.SizedBox(height: 2),
                  pw.Text("$dateToday", style: style2),
                  pw.SizedBox(height: 5),
                  pw.Text("Due Date and Time", style: style1),
                  pw.SizedBox(height: 2),
                  pw.Text("$dueToday", style: style2),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Container(
          padding: const pw.EdgeInsets.only(right: 5),
          color: controller.pdfColorLight.value,
          height: 25,
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 4,
                child: pw.Text(
                  "Description",
                  style: style1,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  "Qty.",
                  style: style1,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  "Unit Price",
                  style: style1,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  "Tax",
                  style: style1,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  "Amount",
                  style: style1,
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        pw.Divider(color: pdfColor3, thickness: 1),
        ...indexList.map(
          (e) => pw.Container(
            padding: const pw.EdgeInsets.only(right: 5),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 4,
                  child:
                      pw.Text("${showProducts[e].productName}", style: style2),
                ),
                pw.Expanded(
                  child: pw.Text(
                    "${showCounter[e]}",
                    style: style2,
                    textAlign: pw.TextAlign.right,
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    "${showProducts[e].price}",
                    style: style2,
                    textAlign: pw.TextAlign.right,
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    "${showTax[e]}",
                    style: style2,
                    textAlign: pw.TextAlign.right,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    "${showTotalList[e]}",
                    style: style2,
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
        pw.Divider(color: pdfColor3, thickness: 1),
        pw.Container(
          color: controller.pdfColorLight.value,
          padding: const pw.EdgeInsets.only(right: 5),
          height: 25,
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 4,
                child: pw.Text(
                  "Total Amount",
                  style: style1,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  "$totalCount",
                  style: style1,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(""),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  totalTax.toStringAsFixed(1),
                  style: style1,
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  "Rs. ${newTotal.toStringAsFixed(1)}",
                  style: style1,
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        pw.Divider(
          color: pdfColor3,
          thickness: 1,
          borderStyle: const pw.BorderStyle(phase: 2),
        ),
        pw.Spacer(),
        pw.Divider(color: pdfColor2),
        pw.Row(children: [
          pw.Text("GST No : ", style: style1),
          pw.Text("${controller.companyGSTNo}", style: style2),
          pw.SizedBox(width: 10),
          pw.Text("Phone Number : ", style: style1),
          pw.Text("${controller.companyNumber}", style: style2),
        ]),
        pw.SizedBox(height: 3),
        pw.Row(
          children: [
            pw.Text("Tax Percentage : ", style: style1),
            pw.Text("${controller.initialTaxValue}%", style: style2),
            pw.SizedBox(width: 10),
            pw.Text("Email : ", style: style1),
            pw.Text("${controller.companyEmail}", style: style2),
          ],
        ),
      ],
    ),
  );
}
