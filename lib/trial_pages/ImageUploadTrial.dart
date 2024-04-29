import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadWidget extends StatefulWidget {
  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  String? imageUrl;
  html.File? imageFile;
  Uint8List? _byte;

  void _getImage() {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*'; // Accept only image files
    input.click();

    input.onChange.listen((e) {
      final List<html.File>? files = input.files;
      if (files != null && files.length == 1) {
        setState(() {
          imageFile = files[0];
        });
        loadImage(imageFile!);
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

      // Initialize Firebase if not already initialized
      await Firebase.initializeApp();

      // Get a reference to the Firebase Storage instance
      final storage = FirebaseStorage.instance;

      // Create a reference to the location where you want to upload the file
      final ref = storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file to Firebase Storage
      final uploadTask = ref.putBlob(imageFile!.slice(), SettableMetadata(contentType: 'image/jpeg'));

      // Get the download URL of the uploaded file
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var bytes;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        imageUrl != null
            ? Image.network(imageUrl!) // Display uploaded image if available
            : imageFile != null
                ? Image.memory(_byte!, fit: BoxFit.cover)
                : Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: double.infinity,
                  ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _getImage,
          child: Text('Select Image'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _uploadImage,
          child: Text('Upload Image'),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Example'),
      ),
      body: Center(
        child: ImageUploadWidget(),
      ),
    ),
  ));
}
