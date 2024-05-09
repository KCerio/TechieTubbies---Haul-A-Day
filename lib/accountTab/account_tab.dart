import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_mobile/accountTab/account_tab_accomplished.dart';
import 'package:haul_a_day_mobile/staffIDController.dart';
import '../AuthController.dart';
import '../components/bottomTab.dart';
import '../components/data/user_information.dart';
import 'account_tab_accountinfo.dart';



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
                              GestureDetector(
                                onTap:(){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AccomplishedDeliveries(staffId: accountInfo.staffID)
                                    ),
                                  );
                                },
                                child: Container(
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




