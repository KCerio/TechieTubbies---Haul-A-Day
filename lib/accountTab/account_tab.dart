import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';
import 'package:haul_a_day_mobile/main.dart';
import 'package:haul_a_day_mobile/staffIDController.dart';
import '../AuthController.dart';
import '../bottomTab.dart';
import '../truckTeamTab/truckteam_tab.dart';
import 'account_tab_accountinfo.dart';

class AccountInfo {
  final String pictureUrl;
  final String staffID;
  final String fullName;
  final String position;
  final String registeredDate;
  final String contactNumber;


  AccountInfo({
    required this.pictureUrl,
    required this.staffID,
    required this.fullName,
    required this.position,
    required this.registeredDate,
    required this.contactNumber,
  });
}

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
  }

  Future<AccountInfo> _initializeData() async {
    final currentStaffId = Get.find<StaffIdController>().getStaffId();
    return getUserDetails(currentStaffId);
  }

  Future<AccountInfo> getUserDetails(String staffId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final firstName = querySnapshot.docs.first['firstname'];
      final lastName = querySnapshot.docs.first['lastname'];
      final fullName = '$firstName $lastName';
      final position = querySnapshot.docs.first['position'];
      final staffID = querySnapshot.docs.first['staffId'];
      final registeredDate = querySnapshot.docs.first['registeredDate'];
      final contactNumber = querySnapshot.docs.first['contactNumber'];
      final pictureUrl = querySnapshot.docs.first['pictureUrl'];;

      return AccountInfo(
        pictureUrl: pictureUrl,
        staffID: staffID,
        fullName: fullName,
        position: position,
        registeredDate: registeredDate,
        contactNumber: contactNumber,
      );
    } else {
      throw Exception('No user found with staff ID: $staffId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<AccountInfo>(
          future: _initializeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.green,));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final accountInfo = snapshot.data!;
              return Container(color: Colors.white,
                child: Column(
                  children: [

                    //Picture and Name
                    Container(
                      height: 150.0,
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 75,
                            backgroundImage: NetworkImage(accountInfo.pictureUrl),
                          ),
                          SizedBox(height: 20),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 40),
                                Text(
                                  accountInfo.fullName,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                Text(
                                  accountInfo.position,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),


                    //Buttons Tab
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50.0),
                            bottom: Radius.zero, // This makes the bottom edges straight
                          ),
                          color: Colors.green[300],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              //Account Information
                              GestureDetector(
                                onTap: () {
                                  // Navigate to AccountInformation class when tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AccountInformation(
                                        pictureUrl: accountInfo.pictureUrl,
                                        staffID: accountInfo.staffID,
                                        fullName: accountInfo.fullName,
                                        position: accountInfo.position,
                                        registeredDate: accountInfo.registeredDate,
                                        contactNumber: accountInfo.contactNumber,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30.0),
                                      bottom: Radius
                                          .zero, // This makes the bottom edges straight
                                    ),
                                    color: Colors.white,
                                  ),
                                  height: 100.0, // Adjust the height as needed
                                  margin: EdgeInsets.only(
                                      top: 30, left: 30, right: 30), // Example margin
                                  padding: EdgeInsets.all(10.0), // Example padding
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.person_search_outlined,
                                        size: 75, // Adjust the size of the icon as needed
                                        color: Colors
                                            .green[700], // Adjust the color of the icon
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // Add spacing between the text widgets
                                            Text(
                                              'Account \nInformation',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green[700]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              //Edit Personal Details
                              Container(
                                color: Colors.grey[300],
                                height: 100.0, // Adjust the height as needed
                                margin: EdgeInsets.only(
                                    left: 30, right: 30), // Example margin
                                padding: EdgeInsets.all(10.0), // Example padding
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.edit_note,
                                      size: 75, // Adjust the size of the icon as needed
                                      color: Colors
                                          .green[700], // Adjust the color of the icon
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Add spacing between the text widgets
                                          Text(
                                            'Edit Personal \nDetails',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //Accomplished Deliveries
                              Container(
                                color: Colors.white,
                                height: 100.0, // Adjust the height as needed
                                margin: EdgeInsets.only(
                                    left: 30, right: 30), // Example margin
                                padding: EdgeInsets.all(10.0), // Example padding
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.checklist_outlined,
                                      size: 75, // Adjust the size of the icon as needed
                                      color: Colors
                                          .green[700], // Adjust the color of the icon
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Add spacing between the text widgets
                                          Text(
                                            'Accomplished \nDeliveries',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //Log Out
                              GestureDetector(
                                onTap: () async {
                                  await AuthController().logout(context);
                                },
                                child: Container(
                                  color: Colors.grey[300],
                                  height: 100.0, // Adjust the height as needed
                                  margin: EdgeInsets.only(left: 30, right: 30), // Example margin
                                  padding: EdgeInsets.all(10.0), // Example padding
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.logout_outlined,
                                        size: 75, // Adjust the size of the icon as needed
                                        color: Colors.green[700], // Adjust the color of the icon
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // Add spacing between the text widgets
                                            Text(
                                              'Logout',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                  height: 110,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                      left: 30, right: 30), // Example margin
                                  padding: EdgeInsets.all(10.0), // Example padding
                                  child: Center(
                                    child: Image.network(
                                        'https://i.ibb.co/qxN1Q3F/h-day.png'),
                                  )),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),);
            }
          },
        ),
        bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    ), onWillPop: () async {
      return false; // Returning false will prevent the user from navigating back
    },);
  }
}




