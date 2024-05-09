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
import '../finished_deliveries_page.dart';

class UploadSuccessfulReport extends StatefulWidget {

  final String deliveryId;
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
  final String nextDeliveryId;

  const UploadSuccessfulReport({Key? key,
    required this.deliveryId,
    required this.orderId,
    required this.team,
    required this.documentation,
    required this.arrivalTimeAndDate,
    required this.completeCartons,
    required this.reasonIncomplete,
    required this.numberCartons,
    required this.recipientName,
    required this.signatory,
    required this.departureTimeAndDate,
    required this.nextDeliveryId,

  }) : super(key: key);

  @override
  _UploadSuccessfulReportState createState() =>
      _UploadSuccessfulReportState();
}



class _UploadSuccessfulReportState extends State<UploadSuccessfulReport> {
  int _currentIndex = 1;

  UploadTask? signatoryUploadTask;
  UploadTask? documentationUploadTask;
  bool _isUploading = false;
  int totalDelivered = 0;

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
                if(!_isUploading){
                  print('next deli: ${widget.nextDeliveryId}');
                  if(widget.deliveryId.startsWith('U')&&widget.nextDeliveryId.isEmpty){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WellDonePage(
                          totalDelivered: totalDelivered ,
                          orderId: widget.orderId,
                        ),
                      ),
                    );

                  }else{
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



  Future<List<String>> uploadFileToStorage() async {

    setState(() {
      _isUploading = true; // Set _isUploading to true when upload is ongoing
    });

    String originalExtension = widget.signatory.path.split('.').last;
    //Signatory
    final signatoryFileName = '${widget.deliveryId}_signatory.$originalExtension';
    final signatoryPath  = 'Orders/${widget.orderId}/Delivery Reports/Successful/$signatoryFileName';
    final signatoryFile = File(widget.signatory.path);
    final signatoryRef = FirebaseStorage.instance.ref().child(signatoryPath);
    signatoryUploadTask = signatoryRef.putFile(signatoryFile);
    final signatorySnapshot = await signatoryUploadTask!.whenComplete(() {});
    final signatoryDownloadURL = await signatorySnapshot.ref.getDownloadURL();


    // Construct the new file name with the same extension
    originalExtension = widget.documentation.path.split('.').last;

    final documentationFileName = '${widget.deliveryId}_documentation.$originalExtension';
    final documentationPath  = 'Orders/${widget.orderId}/Delivery Reports/Successful/$documentationFileName';
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
          .doc('${widget.deliveryId}').set({

        'arrivalTimeDate': widget.arrivalTimeAndDate,
        'departureTimeDate': widget.departureTimeAndDate,
        'completeCartons': widget.completeCartons,
        'reasonIncomplete' :widget.reasonIncomplete,
        'numberCartons' :widget.numberCartons,
        'signatory': urls[0],
        'documentation': urls[1],
        'recipientName': widget.recipientName,
        'isSuccessful' : true,


      }).then((_) async {
        uploadTeam();

        if(widget.deliveryId.startsWith('L')){
          updateStatusLoading();
        }else{
          updateStatusUnloading();
          if(widget.nextDeliveryId==''){
            updateAssignedSchedulesToNone(widget.orderId);
          }
        }
        setState(() {
          _isUploading = false; // Set _isUploading to true when upload is complete
        });



      }).catchError((error) {
        // Show an error message if there's an issue creating the document
        print('Error creating incident report document: $error');
        showErrorDialog(context);

      });
    });
  }

  void uploadTeam(){
    String firestorePath = 'Order/${widget.orderId}/Delivery Reports/${widget.deliveryId}/Attendance';

    widget.team.forEach((member) {
      String staffId = member.staffId;
      FirebaseFirestore.instance.collection(firestorePath).doc(staffId).set({
      }).then((_) {
        print('Team member with staffId $staffId uploaded successfully');
        if(widget.deliveryId.startsWith('U')){
          if(widget.nextDeliveryId==''){
            addToAccomplished(staffId);
          }
        }
      }).catchError((error) {
        print('Error uploading team member with staffId $staffId: $error');
      });
    });

  }

  Future<void> updateStatusLoading() async {
    //set status of next delivery
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Order')
        .doc(widget.orderId)
        .collection('LoadingSchedule')
        .doc(widget.deliveryId)
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
        .doc(widget.deliveryId);

    await documentReference.update({'deliveryStatus': 'Loaded!'});
  }


  Future<void> updateStatusUnloading() async {
    String loadingId = getLoading(widget.deliveryId);

    if(widget.nextDeliveryId!=''){
      final documentReference = FirebaseFirestore.instance
          .collection('Order')
          .doc(widget.orderId)
          .collection('LoadingSchedule')
          .doc(loadingId)
          .collection('UnloadingSchedule')
          .doc(widget.nextDeliveryId);

      await documentReference.update({'deliveryStatus': 'On Route'});
    }



    // Update current loading delivery status in Firestore
    final documentReference = FirebaseFirestore.instance
        .collection('Order')
        .doc(widget.orderId)
        .collection('LoadingSchedule')
        .doc(loadingId)
        .collection('UnloadingSchedule')
        .doc(widget.deliveryId);

    await documentReference.update({'deliveryStatus': 'Delivered!'});

    totalDelivered = await retrieveDelivered(widget.orderId);

    setState(() {

    });




  }


  Future<void> updateAssignedSchedulesToNone(String orderId) async {
    try {
      // Reference to the truckTeam collection
      CollectionReference truckTeamRef = FirebaseFirestore.instance.collection('Order').doc(orderId).collection('truckTeam');

      // Get all documents from the truckTeam collection
      QuerySnapshot truckTeamSnapshot = await truckTeamRef.get();

      // List to store the staff IDs
      List<String> staffIds = [];

      // Iterate over the documents and extract the staff IDs
      truckTeamSnapshot.docs.forEach((doc) {
        staffIds.add(doc.id);
      });

      // Update the assignedSchedule field to "None" for each staff ID in the Users collection
      for (String staffId in staffIds) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('staffId', isEqualTo: staffId)
            .get();

        querySnapshot.docs.forEach((doc) async {

          await doc.reference.update({'assignedSchedule': 'none'});
        });
      }

      // Get the assignedTruck ID from the Order collection
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance.collection('Order').doc(widget.orderId).get();
      String assignedTruckId = orderSnapshot['assignedTruck'];

      // Update truckStatus for the assigned truck in the Trucks collection
      await FirebaseFirestore.instance
          .collection('Trucks')
          .doc(assignedTruckId)
          .update({'truckStatus': 'Available'});

      print('Assigned schedules updated successfully.');
    } catch (e) {
      print("Error updating assigned schedules: $e");
    }
  }

  Future<void> addToAccomplished(String staffId) async {
    try {
      // Retrieve the user document ID corresponding to staffId
      var userQuerySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('staffId', isEqualTo: staffId)
          .get();

      // Check if any documents were found
      if (userQuerySnapshot.docs.isNotEmpty) {
        var userDocId = userQuerySnapshot.docs.first.id;

        // Construct the path to the "Accomplished Deliveries" subcollection
        var accomplishedDeliveriesCollection = FirebaseFirestore.instance
            .collection('Users')
            .doc(userDocId)
            .collection('Accomplished Deliveries');

        // Add a new document to the "Accomplished Deliveries" subcollection
        await accomplishedDeliveriesCollection.doc(widget.orderId).set({

        });

        print('Document added to "Accomplished Deliveries" subcollection');
      } else {
        print('User with staffId $staffId not found');
      }

      // Get the assignedTruck ID from the Order collection
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance.collection('Order').doc(widget.orderId).get();
      String assignedTruckId = orderSnapshot['assignedTruck'];

      // Update truckStatus for the assigned truck in the Trucks collection
      var accomplishedDeliveriesCollection = FirebaseFirestore.instance
          .collection('Trucks')
          .doc(assignedTruckId)
          .collection('Accomplished Deliveries');

      // Add a new document to the "Accomplished Deliveries" subcollection
      await accomplishedDeliveriesCollection.doc(widget.orderId).set({

      });

    } catch (e) {
      print('Error adding document: $e');
    }

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

