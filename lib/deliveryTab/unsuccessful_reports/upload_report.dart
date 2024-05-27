import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:haul_a_day_mobile/components/data/delivery_information.dart';


import 'package:image_picker/image_picker.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../accountTab/account_tab.dart';
import '../../components/data/teamMembers.dart';
import '../../truckTeamTab/truckteam_tab.dart';
import '../delivery_tab.dart';

class UploadUnsuccessfulReport extends StatefulWidget {

  final String deliveryId;
  final String orderId;
  final List<teamMember> team;
  final Timestamp TimeAndDate;
  final XFile documentation;
  final String reason;
  final String reasonSpec;
  final String location;

  const UploadUnsuccessfulReport({Key? key,
    required this.deliveryId,
    required this.orderId,
    required this.team,
    required this.documentation,
    required this.TimeAndDate,
    required this.reason,
    required this.reasonSpec, required this.location,
  }) : super(key: key);

  @override
  _UploadUnsuccessfulReportState createState() =>
      _UploadUnsuccessfulReportState();
}



class _UploadUnsuccessfulReportState extends State<UploadUnsuccessfulReport> {
  int _currentIndex = 1;

  UploadTask? documentationUploadTask;
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
        return true;
    },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[700],
            title: Text(
              'Creating Delivery Report',
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
                    MaterialPageRoute(builder: (context) => DeliveryTab()), // Replace NextPage with the desired page
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
                        ? 'Uploading Report ${widget.deliveryId}'
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
                        : '${widget.deliveryId} submitted to management',
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
          color: Colors.blue[700]!,
          size: 160
      );
    }else{
      return Icon(
        Icons.check_circle_rounded,
        color: Colors.blue[700]!,
        size: 160,
      );
    }
  }

  Future<String> uploadFileToStorage() async {

    setState(() {
      _isUploading = true; // Set _isUploading to true when upload is ongoing
    });


    // Construct the new file name with the same extension
    String originalExtension = widget.documentation.path.split('.').last;

    final documentationFileName = '${widget.deliveryId}_documentation.$originalExtension';
    final documentationPath  = 'Orders/${widget.orderId}/Delivery Reports/Unsuccessful/$documentationFileName';
    final documentationFile = File(widget.documentation.path);
    final documentationRef = FirebaseStorage.instance.ref().child(documentationPath);
    documentationUploadTask = documentationRef.putFile(documentationFile);
    final documentationSnapshot = await documentationUploadTask!.whenComplete(() {});
    final documentationDownloadURL = await documentationSnapshot.ref.getDownloadURL();

    return documentationDownloadURL;

  }

  void createIncidentReport() {

    uploadFileToStorage().then((documentationUrl) {
      // Once the file is uploaded, use the URL to store the incident report information in Firestore
      FirebaseFirestore.instance.collection('Order/${widget.orderId}/Delivery Reports')
          .doc('${widget.deliveryId}-Unsuccessful').set({

        'TimeDate': widget.TimeAndDate,
        'reason':widget.reason,
        'reasonSpecified':widget.reasonSpec??'',
        'documentation': documentationUrl,
        'isSuccessful' : false,
        'location':widget.location,


      }).then((_) async {
        uploadTeam();

        await haltStatus(widget.orderId);

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

  void uploadTeam(){
    String firestorePath = 'Order/${widget.orderId}/Delivery Reports/${widget.deliveryId}-Unsuccessful/Attendance';

    widget.team.forEach((member) {
      String staffId = member.staffId;
      FirebaseFirestore.instance.collection(firestorePath).doc(staffId).set({
      }).then((_) {
        print('Team member with staffId $staffId uploaded successfully');
      }).catchError((error) {
        print('Error uploading team member with staffId $staffId: $error');
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
}

