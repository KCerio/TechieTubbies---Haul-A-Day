

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/web_Pages/truckList/truckInfoPanel/truckInfo.dart';

import '../../../service/database.dart';

class TruckTeamList extends StatefulWidget {
  final String driver;

  TruckTeamList({Key? key, required this.driver}) : super(key: key);

  @override
  State<TruckTeamList> createState() => _TruckTeamListState();
}

class _TruckTeamListState extends State<TruckTeamList> {
  bool isFetching = true;
  List<Map<String, dynamic>> crew = [];
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _initializeTruckData();
  }

  Future<void> _initializeTruckData() async {
    setState(() {
      isFetching = true;
    });
    crew = await fetchCrew(widget.driver);
    setState(() {
      isFetching = false;
    });
  }

  Future<List<Map<String, dynamic>>> fetchCrew(String driver) async {

    if(driver!='none'){
      Map<String, dynamic> _driver = await fetchStaffDetails(driver);

      print('driver: ${_driver['staffId']}, ${_driver['firstname']}');
      crew.add(_driver);

      if (_driver['assignedSchedule'] != 'none') {
        try {
          // Query the Firestore collection "Orders/orderId/truckTeam"
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('Order/${_driver['assignedSchedule']}/truckTeam')
              .get();

          // Extract staff IDs, excluding the driver ID
          List<String> staffIds = querySnapshot.docs
              .where((doc) => doc.id != driver) // Exclude the driver ID
              .map((doc) => doc.id)
              .toList();

          // Check if staffIds list is not empty
          if (staffIds.isNotEmpty) {
            // Fetch details of each staff member and add to the crew list
            for (String staffId in staffIds) {
              Map<String, dynamic> staffDetails = await fetchStaffDetails(staffId);
              crew.add(staffDetails);
            }
          } else {
            print('No staffIds found in truckTeam collection');
          }
        } catch (e) {
          print('Error fetching team members: $e');
          throw e; // Re-throw the error to propagate it
        }
      }

      setState(() {
        isFetching =false;
      });
      return crew;
    }else{
      setState(() {
        isFetching =false;
      });
      return [];
    }


  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Truck Team',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Expanded(
            child: isFetching
                ? Center(child: CircularProgressIndicator())
                : (crew.isEmpty)
                ?Center(
              child: Text(
                'No Driver Assigned',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),)
                :ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              itemCount: crew.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> member = crew[index];
                return Column(
                  children: [
                    memberCard(member),
                    SizedBox(height: 5),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget memberCard(Map<String, dynamic> member) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical:10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor:
            Colors.white,
            backgroundImage: member['pictureUrl'] != null
                ? NetworkImage(member['pictureUrl'])
                : Image.asset('images/user_pic.png').image,
          ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member['firstname']??''+ ' '+member['lastname']??'',
                style: TextStyle(
                    fontSize: 20, color: Colors.grey[600], fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                member['staffId']??'',
                style: TextStyle(
                    fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                member['contactNumber']??'',
                style: TextStyle(
                    fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Spacer(),
          Text(
            member['position']??'',
            style: TextStyle(
                fontSize: 20, color: Colors.grey[600], fontWeight: FontWeight.w500, fontStyle:FontStyle.italic ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
