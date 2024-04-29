import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_mobile/staffIDController.dart';
import 'package:haul_a_day_mobile/truckTeamTab/truckteam_incidentreport.dart';

import '../components/bottomTab.dart';

class TruckInfo {
  final String cargoType;
  final int maxCapacity;
  String truckStatus;
  final String truckType;
  final String driver;
  final String truckPic;


  TruckInfo({
    required this.cargoType,
    required this.maxCapacity,
    required this.truckStatus,
    required this.truckType,
    required this.driver,
    required this.truckPic,
  });
}

class TruckTeam extends StatefulWidget {
  @override
  _TruckTeamState createState() => _TruckTeamState();
}

class _TruckTeamState extends State<TruckTeam> {
  int _currentIndex = 0;
  String currentStaffId = '';
  String firstName = '';
  String truckId = '';
  String position ='';
  TruckInfo? truckInfo;
  String userAssignedSchedule='';

  List<String> truckStatuses = [];
  String? selectedItem;

  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _initializeData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _initializeData() async {
    currentStaffId = Get.find<StaffIdController>().getStaffId();
    firstName = await getFirstName(currentStaffId);
    truckId = await getTruckIdByStaffId(currentStaffId);
    position = await getPosition(currentStaffId);
    userAssignedSchedule = await getSchedule(currentStaffId);



    if (truckId != "none"&& truckId !='no truck') {
      truckInfo = await getTruckInfoByTruckId(truckId);
      truckStatuses = getDropdown(truckInfo!);
    }
    if (_isMounted) {
      setState(() {
      });
    }
  }

  Future<String> getFirstName(String staffId)async{
    String firstName = '';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the firstName from the document
      firstName = querySnapshot.docs.first['firstname'];
    }
    return firstName;
  }

  Future<String> getPosition(String staffId)async{
    String position = '';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the firstName from the document
      position = querySnapshot.docs.first['position'];
    }
    return position;
  }

  Future<String> getTruckIdByStaffId(String staffId) async {
    String position = '';
    String assignedSchedule='';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the position from the document
      position = querySnapshot.docs.first['position'];
    }

    if (position == 'Driver') {
      String truckId;
      try {
        truckId = querySnapshot.docs.first['truck'];
        if(truckId=='')
          truckId = 'no truck';
      } catch (e) {
        truckId = 'no truck';
        print('truckId: ${truckId}');
      }
      return truckId;
    }
    else {
      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve the assignedSchedule from the document
        assignedSchedule = querySnapshot.docs.first['assignedSchedule'];
      }

      if (assignedSchedule == 'none') {
        return "none";
      } else {
        DocumentSnapshot truckQuerySnapshot = await FirebaseFirestore.instance
            .collection('Order')
            .doc(assignedSchedule)
            .get();

        if (truckQuerySnapshot.exists) {
          // Retrieve the assigned truck from the document
          return truckQuerySnapshot['assignedTruck'];
        } else {
          // Handle the case where the document doesn't exist
          throw Exception("Truck document not found for assigned schedule: $assignedSchedule");
        }
      }
    }


  }

  Future<TruckInfo> getTruckInfoByTruckId(String truckId) async {
    DocumentSnapshot truckSnapshot = await FirebaseFirestore.instance
        .collection('Trucks')
        .doc(truckId)
        .get();

    if (truckSnapshot.exists) {
      // Retrieve truck information from the document
      return TruckInfo(
        cargoType: truckSnapshot['cargoType'],
        maxCapacity: truckSnapshot['maxCapacity'],
        truckStatus: truckSnapshot['truckStatus'],
        truckType: truckSnapshot['truckType'],
        driver: truckSnapshot['driver'],
        truckPic: truckSnapshot['truckPic']
      );
    } else {
      // Handle the case where the document doesn't exist
      throw Exception("Truck document not found for truck ID: $truckId");
    }
  }

  Future<String> getSchedule(String staffId) async {
    String userAssignedSchedule = '';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the schedule from the document
      userAssignedSchedule = querySnapshot.docs.first['assignedSchedule'];


    }

    return userAssignedSchedule;
  }

  List<String> getDropdown(TruckInfo truck) {
    if(truck.truckStatus=='Available'){
      return ['Available','On-Repair'];
    }else if(truck.truckStatus=='Busy'){
      return ['Busy', 'On-Repair'];
    }else{
      return ['Available', 'On-Repair'];
    }
}



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      return false; // Returning false will prevent the user from navigating back
    },
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: truckId ==""
          ?AppBar(backgroundColor: Colors.white,automaticallyImplyLeading: false,)
          : AppBar(
            leading: Image.asset('assets/images/truck.png'),
            backgroundColor: Colors.white,
            title: Text(
              'Hello, $firstName!',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fade(duration: Duration(milliseconds: 500)).scale(delay: Duration(milliseconds: 500)),
          ),
      body: truckId == ""
          ? Center(
          child: CircularProgressIndicator(color: Colors.green),
      )
          : truckId == "none" ||truckId == 'no truck' //no assigned schedule
          ? Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                  "assets/images/noScheduleTruckTab.png"),
              height: 200,
              width: 200,
            ),
            SizedBox(height: 10),
            Text(
              (truckId == "none")?"No Truck Team has been assigned yet":"No Truck has been assigned to you yet",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Check back again for updates",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : Column(
        children: [
          Container(
            height: 200.0,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 30.0,
              right: 20.0,
            ),
            decoration: BoxDecoration(
              color: Color(0xff2A9530),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black, // Specify the border color here
                      width: 1, // Adjust the border width as needed
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        truckInfo!.truckPic,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      truckId,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${truckInfo?.maxCapacity ?? 'Unknown'} kgs',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      truckInfo?.cargoType ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      height: 30,
                      width: 125,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black, // Specify the border color here
                          width: 1, // Adjust the border width as needed
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: selectedItem = truckInfo?.truckStatus ?? 'Unknown',
                        items: truckStatuses.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: position == 'Driver'
                            ? (String? newValue) async {
                          if(truckInfo?.truckStatus != 'On-Repair' && newValue == 'On-Repair'){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>IncidentReport(truckId: truckId, assignedSchedule:userAssignedSchedule )),
                            );
                          }
                          else{
                            if ((truckInfo?.truckStatus == 'Available' ||
                                truckInfo?.truckStatus == 'Busy') &&
                                newValue == 'On-Repair') {
                              setState(() {
                                selectedItem = newValue;
                                truckInfo!.truckStatus = newValue!;
                              });
                              // Update the truckStatus in Firestore
                              await FirebaseFirestore.instance
                                  .collection('Trucks')
                                  .doc(truckId)
                                  .update({'truckStatus': newValue});
                            }
                            else if (truckInfo?.truckStatus == 'On-Repair') {
                              setState(() {
                                selectedItem = newValue;
                                truckInfo!.truckStatus = newValue!;
                              });
                              // Update the truckStatus in Firestore
                              await FirebaseFirestore.instance
                                  .collection('Trucks')
                                  .doc(truckId)
                                  .update({'truckStatus': newValue});
                            }
                          }
                          }
                            : null,

                        hint:  Text(
                          truckInfo?.truckStatus ?? 'Unknown',
                        ),
                        isExpanded: true,
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    )
    );
  }

}
