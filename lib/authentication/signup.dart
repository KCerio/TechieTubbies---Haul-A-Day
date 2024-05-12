import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_web/models/user_model.dart';
import 'package:haul_a_day_web/repository/user_repository.dart';
import 'package:haul_a_day_web/service/userService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:firebase_storage/firebase_storage.dart';

class SignUp extends StatefulWidget {
  final Function onLogInSelected;
  const SignUp({super.key, required this.onLogInSelected});
  
  @override
  State<SignUp> createState() => _SignUpState();
}


class _SignUpState extends State<SignUp> {
  // text controllers for the textfields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController staffIdController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController contactNumController = TextEditingController();
  
  String adminpassword = "";
  String staffId ="";
  String _selectedPosition = '';
  String position = '';
  List<String> positions = [
    'Executive',
    'Finance Manager',
    'Cargo Manager',
    'Field Coordinator',
    'Clerk',
    'Others'
  ];
  final _formfield = GlobalKey<FormState>();

  var _isObscured1 = true;
  var _isObscured2 = true;
  //final myController = TextEditingController();

  final userRepo = Get.put(UserRepository());
  final _db = FirebaseFirestore.instance;
  UserService userService = UserService();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    staffIdController.dispose();
    usernameController.dispose();
    super.dispose();
  }
  
  void onLoginSelected() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _signUp()async{
    if(_formfield.currentState!.validate()){
      String confirmpass = confirmController.text.trim();
      adminpassword =  passwordController.text.trim();

      //check if confirmed password and password match
      if (confirmpass == adminpassword){
        // check if user (staff id) already exist in database
        String staffId = staffIdController.text.trim();
        DocumentSnapshot documentSnapshot = await _db.collection('Users').doc(staffId).get();
        if (documentSnapshot.exists) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text('User already exists.'),
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
          //upload image to database storage
          await _uploadImage();
          // create user model from the filled text form fields
          Map<String, dynamic> newUser = {
            'id': staffIdController.text.trim(),
            'staffId': staffIdController.text.trim(), 
            'firstname': firstNameController.text.trim(), 
            'lastname': lastNameController.text.trim(), 
            'contactNumber' : contactNumController.text.trim(),
            'position' : _selectedPosition == 'Others' ? position : _selectedPosition,
            'userName': usernameController.text.trim(), 
            'password': adminpassword,
            'pictureUrl' : imageUrl
          };
          userService.createUser(newUser);
          showDialog(context: context, builder: 
          (_) => const AlertDialog(title: Text("Success"), content: Text("Account Added!"),));
          widget.onLogInSelected();
        }
      }
      else{
        showDialog(context: context, builder: 
      (_) => const AlertDialog(title: Text("Error"), content: Text("Your password does not match"),));
      }
    }
  }
  
  void createUser(UserModel user) async{
    await userRepo.createUser(user);
  }

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
      if(staffId == '') return;

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
                  Text('Signing up...'),
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
      final ref = storage.ref().child('Users/$staffId/profilepic');

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
    Size size = MediaQuery.of(context).size;
    
    return Padding(
      padding: EdgeInsets.all(0),//size.height > 770 ? 64 : size.height > 670 ? 32 : 16),
      child: Center(
        child: Card(
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: AnimatedContainer(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical:20),
            duration: const Duration(milliseconds: 200),
            height: size.height, //* (size.height > 970 ? 0.7 : size.height > 670 ? 0.8 : 0.9),
            width: size.width * 0.5,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Form(
                    key: _formfield,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset("images/logo1.png", 
                        fit: BoxFit.scaleDown
                        )
                      ),

                      const Text(
                        "Fill in your details below",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 0, 0, 0),
                          //fontWeight: FontWeight.bold 
                        ),
                      ),

                      

                      Container(
                          padding: EdgeInsets.only(top:16,left: 24),
                          height:300,
                          //color: Colors.blue,             
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 200,
                                width: 200,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                ),
                                child: _byte == null
                                    ? IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        onPressed: () async {
                                          _getImage();
                                          
                                        },
                                      )
                                    : InkWell(onTap: _getImage,child: Image.memory(_byte!, fit: BoxFit.cover))
                              ),
                              SizedBox(height: 10,),
                              Text("Add Your Picture", style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),


                      // firstname and lastname text fields
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onFieldSubmitted: (_) {
                               _signUp();
                              },
                              validator: (value){
                              if(value!.isEmpty){
                                return "Enter First Name";
                              }else{
                                bool  isValidName = RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
                                if(!isValidName){
                                  return "Invalid first name. It should not\ninclude numbers and symbols";
                                }
                              }
                              return null;
                              },
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                //suffixIcon: Icon(Icons.check),
                              ),
                            ),
                          ),
                      const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: TextFormField(
                              onFieldSubmitted: (_) {
                               _signUp();
                              },
                              validator: (value){
                              if(value!.isEmpty){
                                return "Enter Last Name";
                              }else{
                                bool  isValidName = RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
                                if(!isValidName){
                                  return '''Invalid last name. It should not\ninclude numbers and symbols''';
                                }
                              }
                              return null;
                              },
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                //suffixIcon: Icon(Icons.check),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),


                      //text field for Staff Id
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onFieldSubmitted: (_) {
                                setState(() {
                                  staffId = staffIdController.text;
                              });
                              _signUp();
                              },
                              validator: (value){
                                    if(value!.isEmpty){
                                      return "Enter your Staff ID";
                                    }else{
                                      bool  isValidStaffId = RegExp(r'^CUC-\d{3}$').hasMatch(value);
                                      if(!isValidStaffId){
                                        return "Invalid Staff ID.";
                                      }
                                    }
                                    return null;
                                },
                              controller: staffIdController,
                              decoration: const InputDecoration(
                                //hintText: 'Staff ID',
                                labelText: 'Staff ID#',
                                //suffixIcon: Icon(Icons.check)
                              ),
                            ),
                          ),
                      const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: TextFormField(
                              onFieldSubmitted: (_) {
                              _signUp();
                              },
                              validator: (value){
                                    if(value!.isEmpty){
                                      return "Enter your contact number.";
                                    }else{
                                      bool  isValidStaffId = RegExp(r'^09\d{9}$').hasMatch(value);
                                      if(!isValidStaffId){
                                        return "Invalid Contact Number.";
                                      }
                                    }
                                    return null;
                                },
                              controller: contactNumController,
                              decoration: const InputDecoration(
                                //hintText: 'Staff ID',
                                labelText: 'Contact No.',
                                //suffixIcon: Icon(Icons.check)
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select your position:'),
                          DropdownButtonFormField(
                            value: _selectedPosition.isNotEmpty ? _selectedPosition : null,
                            items: positions.map((position) {
                              return DropdownMenuItem(
                                value: position,
                                child: Text(position),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPosition = value.toString();
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a position';
                              }
                              return null;
                            },
                          ),
                          if (_selectedPosition == 'Others') ...[
                            SizedBox(height: 20),
                            Text('Enter your position:'),
                            TextFormField(
                              onChanged: (value) {
                                position = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your position';
                                }
                                return null;
                              },
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(
                        height: 32,
                      ),

                      //text field for username
                      TextFormField(
                        onFieldSubmitted: (_) {
                         _signUp();
                        },
                        validator: (value){
                              if(value!.isEmpty){
                                return "Enter username";
                              }else{
                                bool  isValidName = RegExp(r'^[a-zA-Z0-9]+(?:[._-]?[a-zA-Z0-9]+)*$').hasMatch(value);
                                if(!isValidName){
                                  return "Invalid username";
                                }
                              }
                              return null;
                          },
                        controller: usernameController,
                        decoration: const InputDecoration(
                          //hintText: 'Username',
                          labelText: 'Username',
                          //suffixIcon: Icon(Icons.check, color: Colors.green)
                        ),
                      ),

                      const SizedBox(
                        height: 32,
                      ),


                      //textfield  for password with obscure text
                      TextFormField(
                        onFieldSubmitted: (_) {
                         _signUp();
                        },
                         validator: (value){
                              if(value!.isEmpty){
                                return "Enter password";
                              }else{
                                bool  isValidPassword = RegExp(r'^(?=.*[a-zA-Z\d])[a-zA-Z\d]{8,12}$').hasMatch(value);
                                if(!isValidPassword){
                                  return "Password should contain 8 - 12 characters.";
                                }
                              }
                              return null;
                          },
                        controller: passwordController,
                        obscureText: _isObscured1,
                        decoration: InputDecoration(
                          //hintText: 'Password',
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                _isObscured1 = !_isObscured1;
                              });
                            }, 
                            child: _isObscured1 ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), 
                          )
                        ),
                      ),

                      const SizedBox(
                        height: 32,
                      ),


                      //textfield for confirmation password
                      TextFormField(
                        onFieldSubmitted: (_) async{
                         setState(() {
                                staffId = staffIdController.text;
                              });
                              
                              _signUp();
                        },
                         validator: (value){
                              if(value!.isEmpty){
                                return "Enter password again to confirm your password";
                              }else{
                                bool  isValidPassword = RegExp(r'^(?=.*[a-zA-Z\d])[a-zA-Z\d]{8,12}$').hasMatch(value);
                                if(!isValidPassword){
                                  return "Password should contain 8 - 12 characters.";
                                }
                              }
                              return null;
                        },
                        controller: confirmController,
                        obscureText: _isObscured2,
                        decoration: InputDecoration(
                          //hintText: 'Confirm Password',
                          labelText: 'Confirm Password',
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                _isObscured2 = !_isObscured2;
                              });
                            }, 
                            child: _isObscured2 ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), 
                          )
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      

                      // if user has an account, switch to login widget
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          GestureDetector(
                            onTap: () {
                              widget.onLogInSelected(); //login widget
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "Log In",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),


                    // Sign up button                 
                    ElevatedButton(
                            onPressed: () async {
                              _signUp();
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 102, 179, 101)),
                              foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
                            ), 
                            child: const Text("Sign up",
                            style: TextStyle(
                              color: Colors.white, 
                              letterSpacing:2, 
                              fontSize: 20,
                              fontWeight: FontWeight.bold),  
                            )
                        )
                       
                    ],
                  ),
                  )
                ),
              ),
            ),
      )
      )
    )
    );

    

    }}