import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_mobile/deliveryTab/loading_delivery_report.dart';
import 'package:haul_a_day_mobile/deliveryTab/unloading_delivery_report.dart';
import 'package:haul_a_day_mobile/staffIDController.dart';
import 'package:unicons/unicons.dart';
import '../bottomTab.dart';
import 'delivery_tab_loading_info.dart';
import 'delivery_tab_unloading_info.dart';

import 'package:intl/intl.dart';


class DeliveryTab extends StatefulWidget {
  @override
  _DeliveryTabState createState() => _DeliveryTabState();
}

class LoadingDelivery {
  final String loadingId;
  String deliveryStatus;
  final String cargoType;
  final String loadingLocation;
  final Timestamp loadingTimeDate;
  final int totalCartons;
  final String warehouse;

  LoadingDelivery({
    required this.loadingId,
    required this.deliveryStatus,
    required this.cargoType,
    required this.loadingLocation,
    required this.loadingTimeDate,
    required this.totalCartons,
    required this.warehouse,

  });

}

class UnloadingDelivery{
  final String unloadingId;
  String deliveryStatus;
  final String recipient;
  final String unloadingLocation;
  final Timestamp unloadingTimeDate;
  final int quantity;
  final int weight;
  final int referenceNum;

  UnloadingDelivery({
    required this.unloadingId,
    required this.deliveryStatus,
    required this.recipient,
    required this.unloadingLocation,
    required this.unloadingTimeDate,
    required this.quantity,
    required this.weight,
    required this.referenceNum});

  factory UnloadingDelivery.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UnloadingDelivery(
      unloadingId: doc.id,
      deliveryStatus: data['deliveryStatus'] ?? '',
      recipient: data['recipient'] ?? '',
      unloadingLocation: data['unloadingLocation'] ?? '',
      unloadingTimeDate: data['unloadingTimestamp']??'',
      quantity: data['quantity'] ?? 0,
      weight: data['weight'] ?? 0,
      referenceNum: data['reference_num'] ?? 0,
    );
  }


}

class _DeliveryTabState extends State<DeliveryTab> {
  int _currentIndex = 1;

  //for getting user data
  String userAssignedSchedule = '';
  String currentStaffId = '';

  //List
  LoadingDelivery? loadingDelivery;
  List<UnloadingDelivery> unloadingDeliveries = [];


  int totalDelivered = 0;


  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    currentStaffId = Get.find<StaffIdController>().getStaffId();
    userAssignedSchedule = await getSchedule(currentStaffId);

    if(userAssignedSchedule!="none"){
      loadingDelivery = await retrieveLoadingDelivery(userAssignedSchedule);
      if (loadingDelivery != null) {
        unloadingDeliveries = await retrieveUnloadingDeliveries(userAssignedSchedule);
        totalDelivered = await retrieveDelivered(userAssignedSchedule);
      }
    }
    setState(() {}); // Update the UI with the retrieved data
  }

  //getting user schedule
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


  // Retrieving loading deliveries
  Future<LoadingDelivery?> retrieveLoadingDelivery(String userAssignedSchedule) async {
    QuerySnapshot loadSnapshot = await FirebaseFirestore.instance
        .collection('Order')
        .doc(userAssignedSchedule) // Access the specific order document
        .collection('LoadingSchedule')
        .get();

    if (loadSnapshot.docs.isNotEmpty) {
      // Assuming there's only one document, retrieve the first one
      DocumentSnapshot firstDocument = loadSnapshot.docs.first;
      return LoadingDelivery(
        loadingId: firstDocument.id,
        deliveryStatus: firstDocument['deliveryStatus'] ?? '',
        cargoType: firstDocument['cargoType'] ?? '',
        loadingLocation: firstDocument['loadingLocation'] ?? '',
        loadingTimeDate: firstDocument['loadingTime_Date'] ?? '',
        totalCartons: firstDocument['totalCartons'] ?? 0,
        warehouse: firstDocument['warehouse'] ?? '',
      );
    } else {
      // If there are no documents, return null
      return null;
    }
  }

  // Retrieving unloading deliveries
  Future<List<UnloadingDelivery>> retrieveUnloadingDeliveries(String userAssignedSchedule) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Order')
        .doc(userAssignedSchedule)
        .collection('LoadingSchedule')
        .doc(loadingDelivery?.loadingId)
        .collection('UnloadingSchedule')
        .get();

    List<UnloadingDelivery> unloadingDeliveries = [];

    if (querySnapshot.docs.isNotEmpty) {
      // Map the documents to UnloadingDelivery objects and add them to the list
      unloadingDeliveries = querySnapshot.docs
          .map((doc) => UnloadingDelivery.fromSnapshot(doc))
          .toList();
    }

    return unloadingDeliveries;
  }

  //Retrieve number of completed deliveries for the counter
  Future<int> retrieveDelivered(String userAssignedSchedule) async {

    //Check number of done deliveries
    int loadedDelivery = (loadingDelivery?.deliveryStatus=="Loaded!")?1:0;
    int totalUndelivered = unloadingDeliveries
        .where((delivery) => delivery.deliveryStatus == 'Delivered!')
        .length;



    return loadedDelivery + totalUndelivered;

  }


  @override
  Widget build(BuildContext context) {
    //appbar configurations
    Color appBarColor =
    userAssignedSchedule == "none" ? Color(0xFFBED8FD) : Colors.white;
    String appBarTitle =
    userAssignedSchedule == "none" ? "No Schedule" : userAssignedSchedule;
    Color appBarTitleColor =
    userAssignedSchedule == "none" ? Colors.white : Color(0xFF3871C1);
    double appBarFontSize = userAssignedSchedule == "none" ? 32 : 32;


    //for the counter
    int totalNeededDeliveries = unloadingDeliveries.length + 1;

    //formated number to make it  "00"
    String formattedTotalDeliveredCount =
    totalDelivered.toString().padLeft(2, '0');
    String formattedTotalNeededDeliveriesCount =
    totalNeededDeliveries.toString().padLeft(2, '0');



    return WillPopScope(child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appBarColor,
          automaticallyImplyLeading: false,
          title: Text(
            appBarTitle,
            style: TextStyle(
              color: appBarTitleColor,
              fontSize: appBarFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: userAssignedSchedule == ""
            ? Center(
          child: CircularProgressIndicator(color: Colors.green),
        )//if data is loading
            : userAssignedSchedule == "none"
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                    "assets/images/noSchedule.png"),
                height: 200,
                width: 200,
              ),
              SizedBox(height: 10),
              Text(
                "No Schedule has been assigned yet",
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
        )//no schedule
            : Column(
          children: [
            //Counter
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Color(0xFF3871C1),
                  width: 10,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        formattedTotalDeliveredCount,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Baseline(
                    baseline: 0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      'out of',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        formattedTotalNeededDeliveriesCount,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Baseline(
                    baseline: 0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      'deliveries done',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),


            ),

            SizedBox(height: 20,),
            //QUEUE
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50.0),
                    bottom: Radius.zero, // This makes the bottom edges straight
                  ),
                  color: Colors.blue[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 3),
                        child: Text(
                          'Delivery Schedule',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontWeight: FontWeight.bold, // Bold font style
                            fontSize: 26, // Font size
                          ),
                        ),
                      ),
                    ), // Title
                    SizedBox(height: 5), // space between the title and the queue
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: unloadingDeliveries.length + 1,
                              itemBuilder: (context, index) {
                                if(loadingDelivery?.deliveryStatus=="On Route"){
                                  if (index == 0) {
                                    return loadingDelivery != null
                                        ? buildLoadingDeliveryContainer(loadingDelivery!)
                                        : Container();
                                  } else {
                                    // Render the unloading deliveries
                                    final unloadingDelivery = unloadingDeliveries[index - 1];
                                    return buildUnloadingDeliveryContainer(unloadingDelivery, index-1);
                                  }
                                }
                                else{
                                  //Render all the unloading Deliveries that are not yet delivered
                                  if ((unloadingDeliveries.length-index)>=totalDelivered) {
                                    final unloadingDelivery = unloadingDeliveries[totalDelivered+index-1];
                                    return buildUnloadingDeliveryContainer(unloadingDelivery, totalDelivered+index-1);
                                  }

                                  //render the loading delivery
                                  else if ((unloadingDeliveries.length-index)==(totalDelivered-1)) {
                                    return loadingDelivery != null
                                        ? buildLoadingDeliveryContainer(loadingDelivery!)
                                        : Container();
                                  }
                                  //render the unloading deliveries that are left (Delivered)
                                  else if(index<=unloadingDeliveries.length) {
                                    int unloadingIndex=totalDelivered-unloadingDeliveries.length + index -2;
                                    final unloadingDelivery = unloadingDeliveries[unloadingIndex];
                                    return buildUnloadingDeliveryContainer(unloadingDelivery, unloadingIndex);
                                  }

                                }
                                return null;

                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


            ),


          ],
        ),
        bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    ), onWillPop: () async {
      return false; // Returning false will prevent the user from navigating back
    },);
  }

  //change container color base on deliveryStatus
  Color getContainerColor(String deliveryStatus){
    if(deliveryStatus=='On Route'){
      return Colors.green;
    }
    else if(deliveryStatus=='On Queue'){
      return Colors.green.withOpacity(0.7);
    }
    else{
      return Colors.grey.withOpacity(0.7);
    }
  }

  Widget buildLoadingDeliveryContainer(LoadingDelivery loadingDelivery) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoadingInformation(loadingDelivery: loadingDelivery, deliveryId: userAssignedSchedule,)),
        );
      },
      child: Container(
        height: 200.0,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Icon(
              UniconsLine.truck_loading,
              size: 150,
              color: getContainerColor(loadingDelivery.deliveryStatus),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${loadingDelivery.loadingId}',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: getContainerColor(loadingDelivery.deliveryStatus),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    intoDate(loadingDelivery.loadingTimeDate),
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    intoTime(loadingDelivery.loadingTimeDate),
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${loadingDelivery.warehouse}, ${loadingDelivery.loadingLocation}',
                    style: TextStyle(fontSize: 14),
                    softWrap: true,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(loadingDelivery.deliveryStatus=="On Route"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>LoadingDeliveryReport(loadingDelivery: loadingDelivery, deliveryId: userAssignedSchedule)),
                        );

                      }
                      else{
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Theme (
                                data: ThemeData( // Customize the theme
                                  dialogBackgroundColor: Colors.white, // Set the background color
                                ),
                                child: SimpleDialog(
                                  children: <Widget>[
                                    Center(
                                      child: GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child:Container(
                                              width: 200,
                                              height: 100,
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Text(
                                                  'Delivery ${loadingDelivery.loadingId} already loaded',
                                                  textAlign: TextAlign.center, // Align text to the center
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                          )
                                      ),
                                    )
                                  ],
                                )
                            );
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(getContainerColor(loadingDelivery.deliveryStatus)),
                    ),
                    child: Text(
                      loadingDelivery.deliveryStatus,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget buildUnloadingDeliveryContainer(UnloadingDelivery unloadingDelivery, int index) {

    return InkWell(
      onTap:(){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UnloadingInformation(unloadingDelivery: unloadingDelivery, deliveryId: userAssignedSchedule,)),
        );


      },
        child: Container(
          height: 200.0,
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 10),
              FaIcon(
                FontAwesomeIcons.truckLoading,
                size: 100,
                color: getContainerColor(unloadingDelivery.deliveryStatus),
              ),
              SizedBox(width: 40),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${unloadingDelivery.unloadingId}',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: getContainerColor(unloadingDelivery.deliveryStatus),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      intoDate(unloadingDelivery.unloadingTimeDate),
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      intoTime(unloadingDelivery.unloadingTimeDate),
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${unloadingDelivery.recipient}, ${unloadingDelivery.unloadingLocation}',
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        //check if it is on the top of the unloading list
                        if(unloadingDelivery.deliveryStatus=='On Route'){
                          UnloadingDelivery? theNextDelivery = null;
                          if(unloadingDeliveries.length-1 != index){
                            theNextDelivery = unloadingDeliveries[index+1];
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>UnloadingDeliveryReport(
                                unloadingDelivery: unloadingDelivery,
                                deliveryId: userAssignedSchedule, nextDelivery: theNextDelivery, loadingDeliveryId: loadingDelivery!.loadingId,
                            )),
                          );

                        }
                        else if(unloadingDelivery.deliveryStatus=='Delivered!'){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Theme (
                                  data: ThemeData( // Customize the theme
                                    dialogBackgroundColor: Colors.white, // Set the background color
                                  ),
                                  child: SimpleDialog(
                                    children: <Widget>[
                                      Center(
                                        child: GestureDetector(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child:Container(
                                                width: 200,
                                                height: 100,
                                                color: Colors.transparent,
                                                child: Center(
                                                  child: Text(
                                                    'Delivery ${unloadingDelivery.unloadingId} already delivered',
                                                    textAlign: TextAlign.center, // Align text to the center
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                            )
                                        ),
                                      )
                                    ],
                                  )
                              );
                            },
                          );
                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Theme (
                                  data: ThemeData( // Customize the theme
                                    dialogBackgroundColor: Colors.white, // Set the background color
                                  ),
                                  child: SimpleDialog(
                                    children: <Widget>[
                                      Center(
                                        child: GestureDetector(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child:Container(
                                                width: 200,
                                                height: 100,
                                                color: Colors.transparent,
                                                child: Center(
                                                  child: Text(
                                                    'Finish "On Route" Delivery first',
                                                    textAlign: TextAlign.center, // Align text to the center
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                            )
                                        ),
                                      )
                                    ],
                                  )
                              );
                            },
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(getContainerColor(unloadingDelivery.deliveryStatus)),
                      ),
                      child: Text(
                        unloadingDelivery.deliveryStatus,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );

  }


  String intoDate (Timestamp timeStamp)  {
    DateTime dateTime = timeStamp.toDate(); // Convert Firebase Timestamp to DateTime
    String formattedDate = DateFormat('MMM d,yyyy').format(dateTime); // Format DateTime into date string
    return formattedDate; // Return the formatted date string
  }

  String intoTime (Timestamp stampTime) {
    DateTime dateTime =  stampTime.toDate();  // Convert Firebase Timestamp to DateTime
    String formattedTime = DateFormat('h:mm a').format(dateTime); // Format DateTime into time string
    return formattedTime; // Return the formatted time string
  }
}




