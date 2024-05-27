import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_mobile/accountTab/uploadPP.dart';
import 'package:image_picker/image_picker.dart';


import '../components/bottomTab.dart';
import '../components/data/user_information.dart';
import 'account_tab_changepassword.dart';


class EditPersonalDetails extends StatefulWidget {
  User account;

   EditPersonalDetails({
    Key? key,
    required this.account
  }) : super(key: key);


  @override
  _EditPersonalDetailsState createState() => _EditPersonalDetailsState();
}

class _EditPersonalDetailsState extends State<EditPersonalDetails> {


   TextEditingController _firstName = TextEditingController();
   TextEditingController _lastName = TextEditingController();
   TextEditingController _username = TextEditingController();
   TextEditingController _contactNumber = TextEditingController();

   XFile? _image =null;
   String imageUrl ='';



   @override
   void initState() {
     super.initState();
     _firstName.text = widget.account.firstName;
     _lastName.text = widget.account.lastName;
     _username.text = widget.account.username;
     _contactNumber.text = widget.account.contactNumber;
     imageUrl = widget.account.pictureUrl;
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
        title: Text(
          'Edit Personal Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [

              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 2, // Blur radius
                      offset: Offset(0, 3), // Offset
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: _image == null
                            ? NetworkImage(imageUrl) as ImageProvider
                            : null,
                        child: _image == null
                            ? null
                            : ClipOval(
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.blue[700]),
                          child: IconButton(
                            onPressed: () {
                              // Add your onPressed callback function here
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Icon(Icons.close,
                                                  color: Colors.black,
                                                  size: 20),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            selectPhoto().then((_) {
                                              setState(() {
                                                Navigator.of(context).pop();
                                              });
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty
                                                .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  // return light blue when pressed
                                                  return Colors.blue[200]!;
                                                }
                                                // return blue when not pressed
                                                return Colors.blue[300]!;
                                              },
                                            ),
                                            minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(200, 50)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Adjust the radius as needed
                                              ),
                                            ),
                                          ),
                                          icon: Icon(
                                              Icons.cloud_upload_outlined,
                                              color: Colors.white,
                                              size: 30), // Icon widget
                                          label: Text(
                                            'Upload a Photo',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight
                                                    .bold), // Set text color
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "OR",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            takePhoto().then((_) {
                                              setState(() {
                                                Navigator.of(context).pop();
                                              });
                                            });


                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty
                                                .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  // return light blue when pressed
                                                  return Colors.blue[200]!;
                                                }
                                                // return blue when not pressed
                                                return Colors.blue[300]!;
                                              },
                                            ),
                                            minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(200, 50)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Adjust the radius as needed
                                              ),
                                            ),
                                          ),
                                          icon: Icon(Icons.camera_alt_outlined,
                                              color: Colors.white,
                                              size: 30), // Icon widget
                                          label: Text(
                                            'Take a Photo',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight
                                                    .bold), // Set text color
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              //FIRST NAME FORM
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: validateName(_firstName.text.trim())?  Colors.transparent:Colors.red[300]!,
                    width: 2.0, // Adjust the border width as needed
                  ),
                ),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'First Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    if(!validateName(_firstName.text.trim()))
                      Text('*',style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0),
                        child: TextFormField(
                          controller: _firstName,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(right:5),
                          ),
                          onChanged: (value) {
                            setState(() {
                            });
                          },
                          style: TextStyle(
                            color: (checkChange(widget.account.firstName, _firstName.text.trim()))
                                ?Colors.grey
                                :Colors.green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                          cursorColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              //LAST NAME FORM
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: validateName(_lastName.text.trim()) ? Colors.transparent:Colors.red[300]!,
                    width: 2.0, // Adjust the border width as needed
                  ),
                ),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'Last Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    if(!validateName(_lastName.text.trim()))
                      Text('*',style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0),
                        child: TextFormField(
                          controller: _lastName,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {

                            setState(() {

                            });
                          },
                          style: TextStyle(
                            color: (checkChange(widget.account.lastName, _lastName.text.trim()))
                                ?Colors.grey
                                :Colors.green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                          cursorColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              //USERNAME FORM
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: validateUserName(_username.text.trim()) ? Colors.transparent: Colors.red[300]!,
                    width: 2.0, // Adjust the border width as needed
                  ),
                ),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'Username',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    if(!validateUserName(_username.text))
                      Text('*',style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0),
                        child: TextFormField(
                          controller: _username,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            color: (checkChange(widget.account.username, _username.text.trim()))
                                ?Colors.grey
                                :Colors.green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (value) {

                            setState(() {

                            });
                          },
                          textAlign: TextAlign.right,
                          cursorColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              //PHONE NUMBER FORM
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: !validatePhone(_contactNumber.text) ? Colors.red[300]!: Colors.transparent,
                    width: 2.0, // Adjust the border width as needed
                  ),
                ),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'Contact Number',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    if(!validatePhone(_contactNumber.text))
                      Text('*',style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0),
                        child: TextFormField(
                          controller: _contactNumber,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(
                              color: (checkChange(widget.account.contactNumber, _contactNumber.text.trim()))
                                  ?Colors.grey
                                  :Colors.green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (value) {
                            setState(() {
                            });
                          },
                          textAlign: TextAlign.right,
                          cursorColor: Colors.grey,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // Allow only digits
                            LengthLimitingTextInputFormatter(11), // Limit to 11 digits
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),


              GestureDetector(
                onTap: () {
                  // Navigate to AccountInformation class when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePassword(account: widget.account,)),
                  );
                },
                child: Text(
                  'Change Password?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20),

              //UPDATE BUTTON
              ElevatedButton(
                onPressed: () {
                  if(isValidated()){

                    //checkChange(widget.account.firstName, _firstName.text.trim());
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return confirmUpdate();
                      },
                    );


                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.sim_card_alert_outlined, color: Colors.red,),
                            SizedBox(width: 5),
                            Text('Enter all necessary fields in correct format to continue'),
                          ],
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }

                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        // return light blue when pressed
                        return Colors.green[200]!;
                      }
                      // return blue when not pressed
                      return Colors.green[700]!;
                    },
                  ),
                  minimumSize:
                  MaterialStateProperty.all<Size>(Size(200, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ), // Set text color
                ),
              ),
            ],
          ),

        ),
      ),
      bottomNavigationBar: BottomTab(currIndex: 2,),
    );
  }


    bool validateName(String s){
    if(s!.isEmpty){
      return false;
    }else{
      bool  isValidName = RegExp(r'^[a-zA-Z\s]+$').hasMatch(s);
      if(!isValidName){
        return false;;
      }
    }
    return true;
  }

   bool validateUserName(String s){
     if(s!.isEmpty){
       return false;
     }else{
       bool  isValidName = RegExp(r'^[a-zA-Z0-9]+(?:[._-]?[a-zA-Z0-9]+)*$').hasMatch(s);
       if(!isValidName){
         return false;
       }
     }
     return true;
   }

   bool validatePhone(String s){
     if(s!.isEmpty){
       return false;
     }else{
       bool  isValidName = RegExp(r'^09\d{9}').hasMatch(s);
       if(!isValidName){
         return false;
       }
     }
     return true;
   }

   bool isValidated(){
     if(validateName(_firstName.text)
         && validateName(_lastName.text)
         && validateUserName(_username.text)
         && validatePhone(_contactNumber.text)
     ){
       return true;
     }else{
       return false;
     }
   }

   Future selectPhoto() async {
     final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

     setState(() {
       _image = image;
       print(_image?.path);
     });
   }

   Future takePhoto() async {
     final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

     setState(() {
       _image = image;
       print(_image?.path);
     });
   }


   Widget confirmUpdate() {
     return AlertDialog(
       title: Text('Confirm Update'),
       content: Text('Are you sure you want to save changes?'),
       actions: [
         TextButton(
           onPressed: () {
             Navigator.of(context).pop(); // Close the dialog
           },
           child: Text('Cancel', style: TextStyle(
             color: Colors.green
           ),),
         ),
         ElevatedButton(
           onPressed: () {
             if(_image==null){
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => UpdateEdittedwithoutPhoto(
                     account: widget.account,
                     newFirstname: _firstName.text.trim(),
                     newLastname: _lastName.text.trim(),
                     newUsername: _username.text.trim(),
                     newContactnumber: _contactNumber.text.trim())),
               );
             }else{
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => UpdateEdittedwithPhoto(
                     account: widget.account,
                     newFirstname: _firstName.text.trim(),
                     newLastname: _lastName.text.trim(),
                     newUsername: _username.text.trim(),
                     newContactnumber: _contactNumber.text.trim(),
                      newImage: _image,
                 )),
               );
             }
             // Close the dialog
            
           },
           child: Text('Confirm', style: TextStyle(
     color: Colors.green
     ),),
         ),
       ],
     );
   }




  bool checkChange(String original, String edit){
    if(original.trim()==edit.trim()){
      return true;
    }
    return false;
  }
}




