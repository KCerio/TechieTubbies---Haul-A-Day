import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_mobile/staffIDController.dart';
import 'package:haul_a_day_mobile/truckTeamTab/truckteam_incidentreport.dart';

import '../components/bottomTab.dart';
import '../components/data/teamMembers.dart';
import '../components/data/truck_info.dart';
import '../components/data/user_information.dart';



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

  List<teamMember> teamList = [];

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
      teamList = await getTeamList(userAssignedSchedule);

    }
    if (_isMounted) {
      setState(() {
      });
    }
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
          ? Padding(padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                      "assets/images/noScheduleTruckTab.png"),
                ),
                SizedBox(height: 10),
                Text(
                  (truckId == "none")?"No Truck Team ":"No Truck",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "has been assigned yet",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Check back again for updates",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            ),)
          : Stack(
          children: [
            Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                bottom: 0,
                child: bg()),

            Positioned(
                top: 0,
                child: truckCard()),

            Positioned(
                top: MediaQuery.of(context).size.height * 0.30,
                bottom: 0,
                left: 0,
                right: 0,
                child: truckTeam(),
            )
          ],

          ),
      bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    )
    );
  }

  Widget truckCard(){
    return Container(
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
    );
  }

  //green background
  Widget bg(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
          bottom: Radius.zero,
        ),
        color: Colors.green[300],
      ),
      width: MediaQuery.of(context).size.width,

    );
  }

  Widget truckTeam(){
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 3),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40.0),
          bottom: Radius.zero,
        ),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 3),
              Text(
                'Crew List',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff2A9530), // Text color
                  fontWeight: FontWeight.bold, // Bold font style
                  fontSize: 26, // Font size
                ),
              ),// Title
              SizedBox(height: 5),
              (teamList.isNotEmpty)
                  ?SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: teamList.length,
                      itemBuilder:(context, index) {
                        teamMember member = teamList[index];
                        return crewCard(member);
                      },
                    )

                  ],
                ),
              )
                  :noCrew()
            ]
        ),
      ),

    );
  }

  Widget crewCard(teamMember member){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color(0xffbed8fd),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(member.pictureUrl),
          ),
          SizedBox(width: 10,),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullname,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                Text(
                  member.position,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  member.contactNum,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget noCrew(){
    return Center(child: Column(
      children: [
        Image.asset("assets/images/no_truckTeam_Driver.png"),
        Text("No Team Assigned Yet",
          textAlign: TextAlign.center, // Align text to the center
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black45,
          ),
        ),

      ],
    ),);
  }


}
