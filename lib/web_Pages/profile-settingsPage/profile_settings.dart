import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haul_a_day_web/web_Pages/profile-settingsPage/edit_profile.dart';
import 'package:haul_a_day_web/web_Pages/profile-settingsPage/password_security.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class Profile_Settings extends StatefulWidget {
  final bool profile;
  final bool settings;
  final Map<String, dynamic> userInfo;
  const Profile_Settings({Key? key, required this.profile, required this.settings, required this.userInfo}) : super(key: key);

  @override
  State<Profile_Settings> createState() => _Profile_SettingsState();
}

class _Profile_SettingsState extends State<Profile_Settings> {
  File? _image;
  bool _isEditingDescriptionMySaga = false;
  bool _isEditingDescriptionPersonals = false;
  TextEditingController _descriptionControllerMySaga = TextEditingController();
  TextEditingController _descriptionControllerPersonals = TextEditingController();
  bool _showProfile = false;
  bool _showEditProfile = false;
  bool _showPasswordSecurity = false;
  Map<String, dynamic> userInfo={};

   @override
  void initState() {
    super.initState();
    if(widget.profile == true){
      setState(() {
        _showProfile = true;
      });
    }else if(widget.settings == true){
      setState(() {
        _showEditProfile = true;
      });

    }
    userInfo = widget.userInfo;    
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical:20, horizontal: 50),
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                padding: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xffE8E7E7),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns the top edges of children
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 20, 20, 0),
                      child: Container(
                        width: 210,
                        height: 190,
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showProfile = true;
                                    _showEditProfile = false;
                                    _showPasswordSecurity = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Itim',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showProfile = false;
                                    _showEditProfile = true;
                                    _showPasswordSecurity = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Itim',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showProfile = false;
                                    _showEditProfile = false;
                                    _showPasswordSecurity = true;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.security,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Password & Security',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Itim',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 2,
                      // width: 20, // Space around the divider
                      // indent: 50, // Top indent
                      // endIndent: 50, // Bottom indent
                    ),
                    if (_showProfile)
                    Padding(
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
                                      'Profile',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: 'Itim',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10), // Adjust the height as needed
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(65, 30, 0, 0),
                                      child: Material(
                                        color: Colors.white,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border:
                                                  Border.all(color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: userInfo['pictureUrl'] != null ? Image.network(userInfo['pictureUrl'])
                                            : Image.asset('images/user_pic.png')
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 130, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${userInfo['firstname']} ${userInfo['lastname']}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Itim',
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person, 
                                        size: 24, 
                                        color: Colors.grey, 
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        userInfo['position'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontFamily: 'Itim',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star, 
                                        size: 24, 
                                        color: Colors.grey, 
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Loyal Employee',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontFamily: 'Itim',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.view_week_outlined, 
                                        size: 24, 
                                        color: Colors.grey, 
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '10+ Cargo Weekly',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontFamily: 'Itim',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Contact Info',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Itim',
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.email, 
                                        size: 24, 
                                        color: Colors.grey, 
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        userInfo['email'] != null ? userInfo['email']
                                        :'No Email Address',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontFamily: 'Itim',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.phone, 
                                        size: 24, 
                                        color: Colors.grey, 
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        userInfo['contactNumber'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontFamily: 'Itim',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 120),
                            Container(
                              width: 300,
                              height: 400,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Text(
                                'My Saga',
                                style: TextStyle(
                                  fontFamily: 'Itim',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              _isEditingDescriptionMySaga
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Material(
                                        child: Container(
                                          color: Colors.white,
                                          width: 250,
                                          height: 100, 
                                          child: TextFormField(
                                            controller: _descriptionControllerMySaga,
                                            decoration: InputDecoration(
                                              labelText: 'Describe who you are',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey), // Set the border color here
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue), // Set the border color here
                                              ),
                                            ),
                                            maxLines: 3, // Allow text to wrap within the TextFormField
                                            textAlignVertical: TextAlignVertical.top,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isEditingDescriptionMySaga = false; // Set editing state to false for My Saga
                                                });
                                              },
                                              style: ButtonStyle(
                                              minimumSize: MaterialStateProperty.all<Size>(Size(40, 30)),
                                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xff3871C1)), // Set background color to blue
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0), // Set border radius to make it rectangular with rounded corners
                                                ),
                                              ),
                                            ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontFamily: 'Itim',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () {
                                               //wako kaybaw sa save button huhu di nako makuha jud
                                              },
                                              style: ButtonStyle(
                                              minimumSize: MaterialStateProperty.all<Size>(Size(40, 30)),
                                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xff3871C1)), // Set background color to blue
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0), // Set border radius to make it rectangular with rounded corners
                                                ),
                                              ),
                                            ),
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                  fontFamily: 'Itim',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                  : TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditingDescriptionMySaga = true;
                                        });
                                      },
                                      child: Center(
                                        child: Text(
                                          'Edit Description',
                                          style: TextStyle(
                                            fontFamily: 'Itim',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                              Text(
                                'Personals',
                                style: TextStyle(
                                  fontFamily: 'Itim',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              _isEditingDescriptionPersonals
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Material(
                                        child: Container(
                                          color: Colors.white,
                                          width: 250,
                                          height: 120, 
                                          child: TextFormField(
                                            controller: _descriptionControllerPersonals,
                                            decoration: InputDecoration(
                                              labelText: 'Your personal info here',
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.grey), // Set the border color here
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.blue), // Set the border color here
                                              ),
                                            ),
                                            maxLines: 5, // Allow text to wrap within the TextFormField
                                            textAlignVertical: TextAlignVertical.top,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isEditingDescriptionPersonals = false; // Set editing state to false for My Saga
                                                });
                                              },
                                              style: ButtonStyle(
                                              minimumSize: MaterialStateProperty.all<Size>(Size(40, 30)),
                                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xff3871C1)), // Set background color to blue
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0), // Set border radius to make it rectangular with rounded corners
                                                ),
                                              ),
                                            ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontFamily: 'Itim',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () {
                                               //wako kaybaw sa save button huhu di nako makuha jud
                                              },
                                              style: ButtonStyle(
                                              minimumSize: MaterialStateProperty.all<Size>(Size(40, 30)),
                                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xff3871C1)), // Set background color to blue
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0), // Set border radius to make it rectangular with rounded corners
                                                ),
                                              ),
                                            ),
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                  fontFamily: 'Itim',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                  : TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditingDescriptionPersonals = true;
                                        });
                                      },
                                      child: Center(
                                        child: Text(
                                          'Edit Information',
                                          style: TextStyle(
                                            fontFamily: 'Itim',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_showEditProfile)
                    EditProfileContainer(userInfo: userInfo,),
                    if (_showPasswordSecurity)
                    PasswordSecurity(userInfo: userInfo),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
