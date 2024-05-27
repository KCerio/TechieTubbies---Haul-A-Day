
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:haul_a_day_mobile/components/data/delivery_information.dart';
import 'package:haul_a_day_mobile/components/data/teamMembers.dart';
import 'package:haul_a_day_mobile/truckTeamTab/truckteam_tab.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../accountTab/account_tab.dart';
import '../components/data/user_information.dart';
import '../deliveryTab/delivery_tab.dart';

class UpdateEdittedwithPhoto extends StatefulWidget{

  final User account;
  final String newFirstname;
  final String newLastname;
  final String newUsername;
  final XFile? newImage;
  final String newContactnumber;


  UpdateEdittedwithPhoto({Key? key,
    required this.account,
    required this.newFirstname,
    required this.newLastname,
    required this.newUsername,
    required this.newImage,
    required this.newContactnumber,
  }) : super(key: key);

  @override
  _UpdateEdittedwithPhotoState createState() => _UpdateEdittedwithPhotoState();
}

class _UpdateEdittedwithPhotoState extends State <UpdateEdittedwithPhoto>{
  int _currentIndex = 2;

  UploadTask? uploadTask;
  bool _isUploading = false;

  @override
  void initState(){
    super.initState();
    updateUser(widget.account.staffID);
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope( onWillPop: () async {
      if(_isUploading)
        return false;
      else
        return true;// Returning false will prevent the user from navigating back
    },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[300],
            title: Text(
              'Updating Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                if(!_isUploading){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountTab()),
                  );
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Details are still being Saved'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),
          body: Center(
            child: GestureDetector(
              onTap: () {
                if (!_isUploading) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountTab()), // Replace NextPage with the desired page
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading(),
                  SizedBox(height: 20),
                  Text(
                    _isUploading
                        ? 'Saving Changes'
                        : 'Success!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _isUploading
                        ? 'Please wait a moment'
                        : 'Account have been updated',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),


          bottomNavigationBar: Stack(
            children: [
              BottomNavigationBar(
                currentIndex: _currentIndex,
                selectedItemColor: Colors.green[700],
                unselectedItemColor: Colors.green[200],
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.truck),
                    label: 'Truck Team',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_rounded),
                    label: 'Delivery',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Account',
                  ),
                ],
                onTap: (index) {
                  if(!_isUploading){
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TruckTeam()),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountTab()),
                      );
                    } else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeliveryTab()),
                      );
                    }
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Account is still Updating'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 3 * _currentIndex,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 3,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ));
  }

  Widget loading(){
    if(_isUploading){
      return LoadingAnimationWidget.inkDrop(
          color: Colors.green,
          size: 160
      );
    }else{
      return Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
        size: 160,
      );
    }
  }

  Future<String> uploadFileToStorage() async {

    setState(() {
      _isUploading = true;
    });



    // Construct the file path in Firebase Storage
    final path = 'Users/${widget.account.staffID}/profilePic';
    final file = File(widget.newImage!.path);
    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();


  }

  Future<void> updateUser(String staffId) async {


    String imageUrl = await uploadFileToStorage();
    try
    {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('staffId', isEqualTo: widget.account.staffID)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
        // Assume there's only one document with the matching staffID
          DocumentSnapshot document = querySnapshot.docs.first;

        // Update the document
         await FirebaseFirestore.instance
            .collection('Users')
            .doc(document.id)
            .update({
        'firstname': widget.newFirstname,
        'lastname': widget.newLastname,
        'pictureUrl': imageUrl,
        'userName': widget.newUsername,
        'contactNumber': widget.newContactnumber,
        });
        } else {
        throw Exception('No user found with staffID: ${widget.account.staffID}');
          }
        } catch (e)
    {
      throw Exception('Failed to update user: $e');
    }

    setState(() {
      _isUploading =false;
    });



  }



  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred while updating your prilfe. Please try again later."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.of(context).pop(); // Go back to the main screen
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


}

class UpdateEdittedwithoutPhoto extends StatefulWidget{

  final User account;
  final String newFirstname;
  final String newLastname;
  final String newUsername;
  final String newContactnumber;


  UpdateEdittedwithoutPhoto({Key? key,
    required this.account,
    required this.newFirstname,
    required this.newLastname,
    required this.newUsername,
    required this.newContactnumber,
  }) : super(key: key);

  @override
  _UpdateEdittedwithoutPhotoState createState() => _UpdateEdittedwithoutPhotoState();
}

class _UpdateEdittedwithoutPhotoState extends State <UpdateEdittedwithoutPhoto>{
  int _currentIndex = 2;

  UploadTask? uploadTask;
  bool _isUploading = false;

  @override
  void initState(){
    super.initState();
    updateUser(widget.account.staffID);
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope( onWillPop: () async {
      if(_isUploading)
        return false;
      else
        return true;// Returning false will prevent the user from navigating back
    },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[300],
            title: Text(
              'Updating Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                if(!_isUploading){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountTab()),
                  );
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Details are still being Saved'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),
          body: Center(
            child: GestureDetector(
              onTap: () {
                if (!_isUploading) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountTab()), // Replace NextPage with the desired page
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading(),
                  SizedBox(height: 20),
                  Text(
                    _isUploading
                        ? 'Saving Changes'
                        : 'Success!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _isUploading
                        ? 'Please wait a moment'
                        : 'Account have been updated',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),


          bottomNavigationBar: Stack(
            children: [
              BottomNavigationBar(
                currentIndex: _currentIndex,
                selectedItemColor: Colors.green[700],
                unselectedItemColor: Colors.green[200],
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.truck),
                    label: 'Truck Team',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_rounded),
                    label: 'Delivery',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Account',
                  ),
                ],
                onTap: (index) {
                  if(!_isUploading){
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TruckTeam()),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountTab()),
                      );
                    } else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeliveryTab()),
                      );
                    }
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Account is still Updating'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 3 * _currentIndex,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 3,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ));
  }

  Widget loading(){
    if(_isUploading){
      return LoadingAnimationWidget.inkDrop(
          color: Colors.green,
          size: 160
      );
    }else{
      return Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
        size: 160,
      );
    }
  }

  Future<void> updateUser(String staffId) async {
    setState(() {
      _isUploading =true;
    });
    try
    {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('staffId', isEqualTo: widget.account.staffID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assume there's only one document with the matching staffID
        DocumentSnapshot document = querySnapshot.docs.first;

        // Update the document
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(document.id)
            .update({
          'firstname': widget.newFirstname,
          'lastname': widget.newLastname,
          'userName': widget.newUsername,
          'contactNumber': widget.newContactnumber,
        });
      } else {
        throw Exception('No user found with staffID: ${widget.account.staffID}');
      }
    } catch (e)
    {
    throw Exception('Failed to update user: $e');
    }

    setState(() {
      _isUploading =false;
    });

  }


  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred while updating your prilfe. Please try again later."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.of(context).pop(); // Go back to the main screen
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


}