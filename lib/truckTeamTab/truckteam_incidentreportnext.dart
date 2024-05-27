

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_mobile/truckTeamTab/truckteam_tab.dart';
import 'package:haul_a_day_mobile/truckTeamTab/uploading_report.dart';
import 'package:intl/intl.dart';
import '../components/bottomTab.dart';
import 'package:image_picker/image_picker.dart';

import '../components/dateThings.dart';

class IncidentReportNext extends StatefulWidget {
  final String truckId;
  final String currentSchedule;
  final String incidentType;
  final String mechanicName;
  final XFile documentation;
  final String incidentDescription;
  final String location;

  const IncidentReportNext({
    Key? key, required this.truckId,
    required this.currentSchedule,
    required this.incidentType,
    required this.mechanicName,
    required this.documentation,
    required this.incidentDescription,
    required this.location}) : super(key: key);



  @override
  _IncidentReportNextState createState() => _IncidentReportNextState();

}

class _IncidentReportNextState extends State<IncidentReportNext> {
  int _currentIndex = 0;
  int progress =80;

  late Timestamp incidentTimeDate;
  String incidentReportNumber='';


  @override
  void initState() {
    super.initState();
    initializeData(); // Call the method to initialize data
  }

  Future<void> initializeData() async {
    incidentTimeDate = getTimeDate();
    incidentReportNumber = await getIncidentReportNumber(widget.truckId);
    setState(() {}); // Call setState to update the UI after data is fetched
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          title: Text(
            'Create Incident Report',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TruckTeam()),
              );
            },
          ),
        ),
        body: incidentReportNumber == ""
            ? Center(
          child: CircularProgressIndicator(color: Colors.green),
        )//if data is loading
            : Column(
          children: [
            //progress bar
            Container(
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 20,
                backgroundColor: Color(0xFFD9D9D9),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),

            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Report Confirmation',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'Confirm the following information before submitting',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //truck Information
                  Container(
                    color: Colors.green[300],
                    child: Column(
                      children: [
                        //truckId
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                'Truck ID',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                widget.truckId,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        //schedule
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                'Current Schedule',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                widget.currentSchedule,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        //reportNum
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                'Incident Report No.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                incidentReportNumber,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        //date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                'Incident Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                intoDate(incidentTimeDate),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        //time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                'Incident Time',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                  10.0), // Adjust the padding values as needed
                              child: Text(
                                intoTime(incidentTimeDate),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  //incident Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                            10.0), // Adjust the padding values as needed
                        child: Text(
                          'Type of Incident',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.incidentType,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true, // Allow text to wrap
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  //mechanic
                  if(widget.mechanicName!='')
                    mechanicWidget(),

                  //location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                            10.0), // Adjust the padding values as needed
                        child: Text(
                          'Location of Incident',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.location,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                            softWrap: true, // Allow text to wrap
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  //documentation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                            10.0), // Adjust the padding values as needed
                        child: Text(
                          'Documentation',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.documentation.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true, // Allow text to wrap
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  //description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                            10.0), // Adjust the padding values as needed
                        child: Text(
                          'Description of Incident',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.incidentDescription,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                            softWrap: true, // Allow text to wrap
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),


                  //buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);

                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {

                                return Colors.green[200]!;
                              }

                              return Colors.green[700]!;
                            },
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)),
                        ),
                        child: Text(
                          'Back',
                          style: TextStyle(color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold), // Set text color
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            progress+=20;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>UploadingReport(
                              truckId: widget.truckId,
                              currentSchedule: widget.currentSchedule,
                              incidentType: widget.incidentType,
                              mechanicName: widget.mechanicName,
                              documentation: widget.documentation,
                              incidentDescription: widget.incidentDescription,
                              incidentReportNumber: incidentReportNumber,
                              incidentTimeDate: incidentTimeDate, location: widget.location,)));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {

                                return Colors.green[200]!;
                              }

                              return Colors.green[700]!;
                            },
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,), // Set text color
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),)
          ],
        ),


        bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    );
  }

  Future<String> getIncidentReportNumber(String truckId) async {
    // Reference to the collection
    CollectionReference incidentReportsCollection =
    FirebaseFirestore.instance.collection('Trucks/$truckId/Incident Reports');

    // Check if the "Incident Reports" collection exists
    bool incidentReportsExists = await FirebaseFirestore.instance.collection('Trucks').doc(truckId)
        .collection('Incident Reports').get().then((snapshot) => snapshot.docs.isNotEmpty)
        ?? false;


    if (incidentReportsExists) {
      // Query the collection to get the last incident report

      QuerySnapshot<Object?> querySnapshot = await incidentReportsCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        // If there are documents in the collection, return the next incident report number
        int nextNumber = querySnapshot.docs.length + 1;
        String nextId = '$truckId-${nextNumber.toString().padLeft(3, '0')}';
        return nextId;
      } else {
        // If the collection is empty, return the initial incident report number
        return '$truckId-001'; // Or any initial value you prefer
      }
    } else {
      return '$truckId-001'; // Or any initial value you prefer
    }
  }

  Widget mechanicWidget(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(
                  10.0), // Adjust the padding values as needed
              child: Text(
                'Name of Mechanic or Repair Shop',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.mechanicName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true, // Allow text to wrap
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );

  }


}





