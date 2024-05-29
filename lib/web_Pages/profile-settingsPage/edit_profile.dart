import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileContainer extends StatefulWidget {
  @override
  State<EditProfileContainer> createState() => _EditProfileContainerState();
}

class _EditProfileContainerState extends State<EditProfileContainer> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
                          onTap: _pickImage,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _image == null
                                  ? Container() // Empty container instead of text
                                  : Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                  child: Row(
                    children: [
                      Material(
                        child: Container(
                          width: 385,
                          height: 40,
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
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: "First Name",
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
                      SizedBox(width: 30),
                      Material(
                        child: Container(
                          width: 385,
                          height: 40,
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
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: "Last Name",
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
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                  child: Material(
                    child: Container(
                      width: 800,
                      height: 40,
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
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                  child: Material(
                    child: Container(
                      width: 800,
                      height: 40,
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
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: "Contact Number",
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
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width:1000,
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                  onPressed: () {},
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
