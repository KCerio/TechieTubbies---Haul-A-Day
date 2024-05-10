
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
import '../deliveryTab/delivery_tab.dart';

class UploadingReport extends StatefulWidget{

  final String truckId;
  final String currentSchedule;
  final String incidentType;
  final String mechanicName;
  final XFile documentation;
  final String incidentDescription;
  final String incidentReportNumber;
  final Timestamp incidentTimeDate;

  const UploadingReport({Key? key,
    required this.truckId,
    required this.currentSchedule,
    required this.incidentType,
    required this.mechanicName,
    required this.documentation,
    required this.incidentDescription,
    required this.incidentReportNumber,
    required this.incidentTimeDate}) : super(key: key);

  @override
  _UploadingReportState createState() => _UploadingReportState();
}

class _UploadingReportState extends State <UploadingReport>{
  int _currentIndex = 0;

  UploadTask? uploadTask;
  bool _isUploading = false;

  @override
  void initState(){
    super.initState();
    createIncidentReport();
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
          'Creating Incident Report',
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
                MaterialPageRoute(builder: (context) => TruckTeam()),
              );
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Report is still Uploading'),
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
                MaterialPageRoute(builder: (context) => TruckTeam()), // Replace NextPage with the desired page
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
                    ? 'Uploading Report ${widget.incidentReportNumber}'
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
                    : '${widget.incidentReportNumber} submitted to management',
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
                    content: Text('Report is still Uploading'),
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
      _isUploading = true; // Set _isUploading to true when upload is ongoing
    });


    String originalExtension = widget.documentation.path.split('.').last;
    final fileName = '${widget.incidentReportNumber}.$originalExtension';

    // Construct the file path in Firebase Storage
    final path = 'Trucks/${widget.truckId}/Incident Reports/$fileName';
    final file = File(widget.documentation.path);
    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();


  }

  void createIncidentReport() {
    // First, upload the file to Firebase Storage
    uploadFileToStorage().then((documentationUrl) {
      // Once the file is uploaded, use the URL to store the incident report information in Firestore
      FirebaseFirestore.instance.collection('Trucks/${widget.truckId}/Incident Reports').doc(widget.incidentReportNumber).set({
        'truckId': widget.truckId,
        'currentSchedule': widget.currentSchedule,
        'incidentType': widget.incidentType,
        'mechanicName': widget.mechanicName,
        'documentation': documentationUrl,
        'incidentDescription': widget.incidentDescription,
        'incidentTimeDate': widget.incidentTimeDate,
      }).then((_) async {

        if(widget.currentSchedule!="none"){

          await createUnsuccessfulReport();
        }
        setState(() {
          _isUploading = false; // Set _isUploading to true when upload is complete
        });

        //set status
        await FirebaseFirestore.instance
            .collection('Trucks')
            .doc(widget.truckId)
            .update({'truckStatus': 'On-Repair'});

        //add dialog


      }).catchError((error) {
        // Show an error message if there's an issue creating the document
        print('Error creating incident report document: $error');
        showErrorDialog(context);

      });
    });
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred while submitting the report. Please try again later."),
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

  Future<void> createUnsuccessfulReport() async {

    String deliveryId = await getOnRouteDelivery(widget.currentSchedule);
    List<teamMember> team = await getTeamList(widget.currentSchedule);

    uploadFileToStorage().then((documentationUrl) {
      // Once the file is uploaded, use the URL to store the incident report information in Firestore
      FirebaseFirestore.instance.collection('Order/${widget.currentSchedule}/Delivery Reports')
          .doc('${deliveryId}-Unsuccessful').set({

        'TimeDate': widget.incidentTimeDate,
        'reason':widget.incidentType,
        'reasonSpecified':(widget.incidentType=="Others")?widget.incidentDescription:'',
        'documentation': documentationUrl,
        'isSuccessful' : false,


      }).then((_) async {
        uploadTeam(deliveryId, team);

        await haltStatus(widget.currentSchedule);

        setState(() {
          _isUploading = false; // Set _isUploading to true when upload is complete
        });

        //updateStatus();

      }).catchError((error) {
        // Show an error message if there's an issue creating the document
        print('Error creating incident report document: $error');
        showErrorDialog(context);

      });
    });
  }

  void uploadTeam(String deliveryId, List<teamMember> team){
    String firestorePath = 'Order/${widget.currentSchedule}/Delivery Reports/${deliveryId}-Unsuccessful/Attendance';


    team.forEach((member) {
      String staffId = member.staffId;
      FirebaseFirestore.instance.collection(firestorePath).doc(staffId).set({
      }).then((_) {
        print('Team member with staffId $staffId uploaded successfully');
      }).catchError((error) {
        print('Error uploading team member with staffId $staffId: $error');
      });
    });

  }
}