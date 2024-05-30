import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

Future<Uint8List> fetchImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

Future<void> generateAndPrintPdf(Map<String, dynamic> aStaff, int helperRate, int driverRate) async {
  final pdf = pw.Document();

  DateTime now = DateTime.now();
  String dateToday = DateFormat('MMMM dd, yyyy').format(now);
  double totalDeduct = aStaff['SSS'] + aStaff['PhilHealth'] + aStaff['Pagibig'];

  final Uint8List fontData = await rootBundle.load("assets/fonts/Itim-Regular.ttf").then((data) => data.buffer.asUint8List());
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  Uint8List profileImageBytes;
  try {
    if (aStaff['pictureUrl'] != null) {
      profileImageBytes = await fetchImage(aStaff['pictureUrl']);
    } else {
      profileImageBytes = await rootBundle.load('images/user_pic.png').then((data) => data.buffer.asUint8List());
    }
  } catch (e) {
    profileImageBytes = await rootBundle.load('images/user_pic.png').then((data) => data.buffer.asUint8List());
  }

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(16.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Pay Slip',
                    style: pw.TextStyle(
                      color: PdfColors.green,
                      fontSize: 32,
                      fontWeight: pw.FontWeight.normal,
                      font: ttf,
                    ),
                  ),
                  pw.Text(
                    dateToday,
                    style: pw.TextStyle(
                      color: PdfColors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                width: 400,
                height: 150,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Container(
                            width: 40,
                            height: 40,
                            decoration: pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                              image: pw.DecorationImage(
                                image: pw.MemoryImage(profileImageBytes),
                                fit: pw.BoxFit.cover,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Text(
                            '${aStaff['firstname']} ${aStaff['lastname']}',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 25),
                      pw.Text(
                        aStaff['netSalary'] != null
                            ? 'Php ${aStaff['netSalary'].toStringAsFixed(2)}'
                            : 'Php 0.00',
                        style: pw.TextStyle(
                          color: PdfColors.grey,
                          fontSize: 26,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                width: 400,
                height: 380,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Breakdown:',
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 20,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total Income',
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            aStaff['position'] == 'Driver' && aStaff['numDays'] != null
                                ? 'Php ${(driverRate * aStaff['numDays']).toStringAsFixed(2)}'
                                : 'Php 0.00',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Salary Rate',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          pw.Text(
                            aStaff['position'] == 'Driver'
                                ? 'Php ${driverRate.toStringAsFixed(2)}'
                                : 'Php ${helperRate.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'No. of Days',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          pw.Text(
                            aStaff['numDays'] != null
                                ? aStaff['numDays'].toString()
                                : '0',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(color: PdfColors.black),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total Deduction',
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Php ${totalDeduct.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'SSS',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          pw.Text(
                            aStaff['SSS'] != null
                                ? 'Php ${aStaff['SSS'].toStringAsFixed(2)}'
                                : 'Php 0.00',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'PhilHealth',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          pw.Text(
                            aStaff['PhilHealth'] != null
                                ? 'Php ${aStaff['PhilHealth'].toStringAsFixed(2)}'
                                : 'Php 0.00',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Pag-ibig',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          pw.Text(
                            aStaff['Pagibig'] != null
                                ? 'Php ${aStaff['Pagibig'].toStringAsFixed(2)}'
                                : 'Php 0.00',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(color: PdfColors.black),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Net Salary',
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            aStaff['netSalary'] != null
                                ? 'Php ${aStaff['netSalary'].toStringAsFixed(2)}'
                                : 'Php 0.00',
                            style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
