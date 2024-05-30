import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:haul_a_day_web/service/userService.dart';
import 'package:universal_html/html.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;



class EditProfileContainer extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  const EditProfileContainer({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<EditProfileContainer> createState() => _EditProfileContainerState();
}

class _EditProfileContainerState extends State<EditProfileContainer> {
  Map<String, dynamic> userInfo = {};
  final _formfield = GlobalKey<FormState>();

  UserService userService = UserService();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumController = TextEditingController();

  String? imageUrl;
  html.File? imageFile;
  Uint8List? _byte;
  bool uploading = false; // Track if image is being uploaded

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo = widget.userInfo;
  }

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
      final ref = storage.ref().child('Users/${userInfo['staffId']}/profilepic');

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
      child: Container(
        width: 1000,
        height: 560,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 30, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Itim',
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(65, 30, 0, 0),
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: _getImage,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _byte != null
                                    ?Image.memory( _byte!, fit: BoxFit.cover)
                                    : userInfo['pictureUrl'] != null
                                    ? Image.network(userInfo['pictureUrl'], fit: BoxFit.cover,)
                                    : Image.asset('images/user_pic.png',fit: BoxFit.cover)
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 60, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: _getImage,
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all<Size>(Size(70, 50)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(
                                      0xff3871C1)), // Set background color to blue
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Set border radius to make it rectangular with rounded corners
                                ),
                              ),
                            ),
                            child: Text(
                              'Change Photo',
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ), // Add a child widget here
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              // Add your onPressed function logic here
                            },
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all<Size>(Size(70, 50)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(
                                      0xff3871C1)), // Set background color to blue
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Set border radius to make it rectangular with rounded corners
                                ),
                              ),
                            ),
                            child: Text(
                              'Delete Photo',
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ), // Add a child widget here
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                LayoutBuilder(
                  builder: (context,constraints) {
                    return Container(
                      height: 220,
                      //color: Colors. blue,
                      child: Form(
                        key: _formfield,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Material(
                                      child: Expanded(
                                        child: Container(
                                          width: 385,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1), // Shadow color
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset:
                                                    Offset(0, 3), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(
                                                20.0), // Match the border radius
                                          ),
                                          child: TextFormField(
                                            controller: firstNameController,
                                            validator: (value){                                
                                              if(value!.isNotEmpty){
                                                bool  isValidName = RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!);
                                                if(!isValidName){
                                                  return "Invalid first name. It should not include numbers and symbols";
                                                }   
                                              }                                
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.person),
                                              labelText: "First Name",
                                              hintText: userInfo['firstname'],
                                              labelStyle: TextStyle(
                                                color: Color(0xff5A5A5A),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 30),
                                    Material(
                                      child: Container(
                                        width: 385,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.1), // Shadow color
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset:
                                                  Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              20.0), // Match the border radius
                                        ),
                                        child: Expanded(
                                          child: TextFormField(
                                            controller: lastNameController,
                                            validator: (value){                                
                                              if(value!.isNotEmpty){
                                                bool  isValidName = RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!);
                                                if(!isValidName){
                                                  return "Invalid last name. It should not include numbers and symbols";
                                                } 
                                              }                                  
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.person),
                                              labelText: "Last Name",
                                              hintText: userInfo['lastname'],
                                              labelStyle: TextStyle(
                                                color: Color(0xff5A5A5A),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                                child: Material(
                                  child: Container(
                                    width: 800,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.1), // Shadow color
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Match the border radius
                                    ),
                                    child: Expanded(
                                      child: TextFormField(
                                        controller: emailController,
                                        validator: (value){                                
                                          if(value!.isNotEmpty){
                                            bool  isValidStaffId = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value!);
                                            if(!isValidStaffId){
                                              return "Invalid Email Address.";
                                            }  
                                          }                     
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.email),
                                          labelText: "Email",
                                          hintText: userInfo['email'] ?? '',
                                          labelStyle: TextStyle(
                                            color: Color(0xff5A5A5A),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                                child: Material(
                                  child: Container(
                                    width: 800,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.1), // Shadow color
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Match the border radius
                                    ),
                                    child: Expanded(
                                      child: TextFormField(
                                        controller: contactNumController,
                                        validator: (value){                                
                                          if(value!.isNotEmpty){
                                            bool  isValidStaffId = RegExp(r'^09\d{9}$').hasMatch(value!);
                                            if(!isValidStaffId){
                                              return "Invalid Contact Number.";
                                            }    
                                          }                   
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.phone),
                                          labelText: "Contact Number",
                                          hintText: userInfo['contactNumber'],
                                          labelStyle: TextStyle(
                                            color: Color(0xff5A5A5A),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),                
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width:1000,
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                  onPressed: ()async {
                    if(_formfield.currentState!.validate()){
                      if(_byte != null){
                        await _uploadImage();
                      }
                      String image = imageUrl ?? userInfo['pictureUrl'];
                      String firstname = firstNameController.text != '' ? firstNameController.text :userInfo['firstname'];
                      String lastname = lastNameController.text != '' ? lastNameController.text :userInfo['lastname'];
                      String email = emailController.text != '' ? emailController.text :userInfo['email'] != null ? userInfo['email'] : '';
                      String contact = contactNumController.text != '' ? contactNumController.text : userInfo['contactNumber'];

                      bool updated = await userService.updateProfile(userInfo['staffId'], firstname, lastname, email, contact, image);
                      if(updated){
                        setState(() {
                          userInfo['firstname'] = firstname;
                          userInfo['lastname'] = lastname;
                          userInfo['email'] = email;
                          userInfo['contactNumber'] = contact;
                          userInfo['pictureUrl'] = image;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Updated'),
                              content: const Text('Your profile information is updated.'),
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
                        );
                      }else{
                        BuildContext? progressContext;
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
                                    Text('Failed to update.'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontFamily: 'Itim', fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3871C1),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: 
            // ),
          ],
        ),
      ),
    );
  }
}
