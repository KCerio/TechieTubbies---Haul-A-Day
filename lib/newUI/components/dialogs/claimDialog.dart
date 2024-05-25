import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/payrollService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ClaimDialog extends StatefulWidget {
  final String path;
  final String staffId;
  final Function(Map<String,dynamic>?) status;
  const ClaimDialog({super.key, required this.path, required this.staffId, required this.status});

  @override
  State<ClaimDialog> createState() => _ClaimDialogState();
}

class _ClaimDialogState extends State<ClaimDialog> {
  PayrollService payrollService = PayrollService();
  String name ='';
  String todayDate = DateFormat('d MMMM, yyyy').format(DateTime.now()).toUpperCase();

  String? imageUrl;
  html.File? imageFile;
  Uint8List? _byte;
  bool uploading = false; // Track if image is being uploaded

  void _getImage() {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*'; // Accept only image files
    input.click();

    input.onChange.listen((e) {
      final List<html.File>? files = input.files;
      if (files != null && files.length == 1) {
        final html.File file = files[0];
        final String fileType = file.type.toLowerCase(); // Get the file type

        // Check if the file type starts with 'image/'
        if (!fileType.startsWith('image/')) {
          // File is not an image, show alert dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text('Invalid file format. Please upload an image file.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // File is an image, proceed with handling
          setState(() {
            imageFile = file;
          });
          loadImage(imageFile!);
        }
      }
    });
  }


  void loadImage(html.File _imageFile) {
    if (_imageFile != null) {
      final reader = html.FileReader();
      reader.readAsDataUrl(_imageFile);
      reader.onLoadEnd.listen((event) {
        var _byteData = base64.decode(reader.result.toString().split(',').last);
        setState(() {
          _byte = _byteData;
        });
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (imageFile == null) return;

      // Set uploading flag to true
      setState(() {
        uploading = true;
      });

      // Declare progressContext outside the showDialog function
      BuildContext? progressContext;

      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // Update progressContext inside the showDialog function
          progressContext = context;
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Uploading Image...'),
                ],
              ),
            ),
          );
        },
      );

      // Initialize Firebase if not already initialized
      await Firebase.initializeApp();

      // Get a reference to the Firebase Storage instance
      final storage = FirebaseStorage.instance;

      // Create a reference to the location where you want to upload the file
      final ref = storage.ref().child('Payroll/Claim/$name/$todayDate');

      // Upload the file to Firebase Storage
      final uploadTask = ref.putBlob(imageFile!.slice(), SettableMetadata(contentType: 'image/jpeg'));

      // Get the download URL of the uploaded file
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        uploading = false;
        imageUrl = downloadUrl;
      });

      // Dismiss the progress dialog using the progressContext
      if (progressContext != null) {
        Navigator.pop(progressContext!);
      }

      print("Url: $imageUrl");
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        uploading = false;
      });
    }
  }

    
  
  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('d MMMM, yyyy').format(DateTime.now()).toUpperCase();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 500, // Set the desired width
        height: 360,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xffBED8FD),
            width: 4,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Claim Payroll',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Itim'),
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$todayDate',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Itim',
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width:250,
                          height: 35,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Claimed by',
                              labelStyle: TextStyle(
                                color: Color(0xff5A5A5A),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Color(0xffBED8FD), width: 2.0), // Add border color here
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.blue, width: 2.0), // Add border color here for when the field is focused
                              ),
                            ),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Signatory',
                        style: TextStyle(
                          fontFamily: 'Itim',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Container(
                        width: 140, // Set the desired width
                        height: 120, // Set the desired height
                        decoration: BoxDecoration(
                          color: Color(0xffD3F0FE), // Background color
                          borderRadius: BorderRadius.circular(20.0), // Rounded edges
                        ),
                        child: _byte != null ? Image.memory(_byte!, fit: BoxFit.cover)
                        : Container()
                      ),
                      SizedBox(height: 5),
                      Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  _getImage();
                                  // setState(() {
                                  //   imageAdded = true;
                                  // });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // Button color
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.upload_file_rounded,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'Upload file',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Itim',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 30,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff3871C1),
              ),
              child: TextButton(
                onPressed: () async {
                  if(name != '' && _byte != null){
                    await _uploadImage();
                    //imageUrl - Claimed Picture
                    bool finish = await payrollService.claimPayroll(widget.path, name, imageUrl!, widget.staffId);
                    if(finish){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Successful'),
                            content: Text('Pay claimed'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {        
                                  Navigator.of(context).pop();
                                  widget.status({
                                    'status' : 'Claimed',
                                    'name' : name,
                                    'image' : imageUrl,
                                    'date' : DateTime.now().toString(),
                                    });
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );    // Close the dialog
                    }else{
                       showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Alert'),
                            content: Text('There was an error'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {        
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );    // Close the dialog
                    }
                  } else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content: Text('Please fill in the name of the person who will claim this payroll and a picture of their signature.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {        
                                
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );    // Close the dialog
                  }
                },
                child: Text(
                  'Claim',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}