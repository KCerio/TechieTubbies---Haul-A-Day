import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';
import 'package:haul_a_day_mobile/deliveryTab/loading_successful_reports/loading_delivery_report_successful.dart';
import 'package:image_picker/image_picker.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../accountTab/account_tab.dart';
import '../../truckTeamTab/truckteam_tab.dart';

class UploadLoadingSucc extends StatefulWidget {

  final LoadingDelivery loadingDelivery;
  final String orderId;
  final List<teamMember> team;
  final Timestamp arrivalTimeAndDate;
  final bool completeCartons;
  final String reasonIncomplete;
  final int numberCartons;
  final String recipientName;
  final XFile signatory;
  final XFile documentation;
  final Timestamp departureTimeAndDate;

  const UploadLoadingSucc({Key? key,
    required this.loadingDelivery,
    required this.orderId,
    required this.team,
    required this.arrivalTimeAndDate,
    required this.completeCartons,
    required this.reasonIncomplete,
    required this.recipientName,
    required this.signatory,
    required this.documentation,
    required this.departureTimeAndDate, required this.numberCartons}) : super(key: key);

  @override
  _UploadLoadingSuccState createState() =>
      _UploadLoadingSuccState();
}



class _UploadLoadingSuccState extends State<UploadLoadingSucc> {
  int _currentIndex = 1;

  UploadTask? signatoryUploadTask;
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
                        ? 'Uploading Report ${widget.loadingDelivery.loadingId}'
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
                        : '${widget.loadingDelivery.loadingId} submitted to management',
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

  Future<List<String>> uploadFileToStorage() async {

    setState(() {
      _isUploading = true; // Set _isUploading to true when upload is ongoing
    });

    String originalExtension = widget.signatory.path.split('.').last;
    //Signatory
    final signatoryFileName = '${widget.loadingDelivery.loadingId}_signatory.$originalExtension';
    final signatoryPath  = 'Orders/${widget.orderId}/Delivery Reports/Loading/$signatoryFileName';
    final signatoryFile = File(widget.signatory.path);
    final signatoryRef = FirebaseStorage.instance.ref().child(signatoryPath);
    signatoryUploadTask = signatoryRef.putFile(signatoryFile);
    final signatorySnapshot = await signatoryUploadTask!.whenComplete(() {});
    final signatoryDownloadURL = await signatorySnapshot.ref.getDownloadURL();


    // Construct the new file name with the same extension
     originalExtension = widget.documentation.path.split('.').last;

    final documentationFileName = '${widget.loadingDelivery.loadingId}_documentation.$originalExtension';
    final documentationPath  = 'Orders/${widget.orderId}/Delivery Reports/Loading/$documentationFileName';
    final documentationFile = File(widget.documentation.path);
    final documentationRef = FirebaseStorage.instance.ref().child(documentationPath);
    documentationUploadTask = documentationRef.putFile(documentationFile);
    final documentationSnapshot = await documentationUploadTask!.whenComplete(() {});
    final documentationDownloadURL = await documentationSnapshot.ref.getDownloadURL();

    return [signatoryDownloadURL, documentationDownloadURL];

  }

  void createIncidentReport() {

    uploadFileToStorage().then((urls) {
      // Once the file is uploaded, use the URL to store the incident report information in Firestore
      FirebaseFirestore.instance.collection('Order/${widget.orderId}/Delivery Reports')
          .doc('${widget.loadingDelivery.loadingId}').set({

        'arrivalTimeDate': widget.arrivalTimeAndDate,
        'departureTimeDate': widget.departureTimeAndDate,
        'completeCartons': widget.completeCartons,
        'reasonIncomplete' :widget.reasonIncomplete,
        'numberCartons' :widget.numberCartons,
        'signatory': urls[0],
        'documentation': urls[1],
        'recipientName': widget.recipientName,



      }).then((_) async {
        uploadTeam();

        setState(() {
          _isUploading = false; // Set _isUploading to true when upload is complete
        });

        updateStatus();

      }).catchError((error) {
        // Show an error message if there's an issue creating the document
        print('Error creating incident report document: $error');
        showErrorDialog(context);

      });
    });
  }

  void uploadTeam(){
    String firestorePath = 'Order/${widget.orderId}/Delivery Reports/${widget.loadingDelivery.loadingId}/Attendance';

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

  Future<void> updateStatus() async {
    //set status of next delivery
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Order')
        .doc(widget.orderId)
        .collection('LoadingSchedule')
        .doc(widget.loadingDelivery.loadingId)
        .collection('UnloadingSchedule')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;
      await documentSnapshot.reference.update({'deliveryStatus': 'On Route'});
    }


    // Update current loading delivery status in Firestore
    final documentReference = FirebaseFirestore.instance
        .collection('Order')
        .doc(widget.orderId)
        .collection('LoadingSchedule')
        .doc(widget.loadingDelivery.loadingId);

    await documentReference.update({'deliveryStatus': 'Loaded!'});
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

