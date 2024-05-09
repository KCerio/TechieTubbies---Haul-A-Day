import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_mobile/deliveryTab/loading_delivery_report.dart';
import 'package:haul_a_day_mobile/deliveryTab/unloading_delivery_report.dart';
import 'package:haul_a_day_mobile/staffIDController.dart';
import 'package:unicons/unicons.dart';
import '../components/bottomTab.dart';
import '../components/data/delivery_information.dart';
import '../components/data/user_information.dart';
import '../components/dateThings.dart';
import 'delivery_tab_loading_info.dart';
import 'delivery_tab_unloading_info.dart';

import 'package:intl/intl.dart';


class DeliveryTab extends StatefulWidget {
  @override
  _DeliveryTabState createState() => _DeliveryTabState();
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
        unloadingDeliveries = await retrieveUnloadingDeliveries(userAssignedSchedule, loadingDelivery!.loadingId);
        totalDelivered = await retrieveDelivered(userAssignedSchedule);
      }
    }
    setState(() {}); // Update the UI with the retrieved data
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
            ? Padding(
          padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/noSchedule.png"),
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
        ),)//no schedule
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
      return false;
    },);
  }

  //change container color base on deliveryStatus
  Color getContainerColor(String deliveryStatus){
    if(deliveryStatus=='On Route'){
      return Colors.green;
    }
    else if(deliveryStatus=='On Queue'){
      return Colors.green.withOpacity(0.7);
    }else if(deliveryStatus=='Halted'){
      return Color(0xFF3871C1);
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
        //height: 200.0,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        padding: EdgeInsets.all(20.0),
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
              size: MediaQuery.of(context).size.width*0.32,
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
                  SizedBox(height: 10,),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if(loadingDelivery.deliveryStatus=="On Route"){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>LoadingDeliveryReport(loadingDelivery: loadingDelivery, deliveryId: userAssignedSchedule)),
                          );

                        }
                        else if(loadingDelivery.deliveryStatus=="Halted"){
                          showHalted(loadingDelivery.loadingId);

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
                                                padding: EdgeInsets.all(10),
                                                color: Colors.transparent,
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      FaIcon(FontAwesomeIcons.boxesPacking,
                                                          size: 40,color: Colors.green ),
                                                      Text(
                                                        'Delivery ${loadingDelivery.loadingId}',
                                                        textAlign: TextAlign.center, // Align text to the center
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.green
                                                        ),
                                                      ),
                                                      Text(
                                                        'already loaded',
                                                        textAlign: TextAlign.center, // Align text to the center
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.black
                                                        ),
                                                      ),
                                                    ]
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
                  )
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
          //height: 200.0,
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          padding: EdgeInsets.all(20.0),
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
                size: MediaQuery.of(context).size.width*0.24,
                color: getContainerColor(unloadingDelivery.deliveryStatus),
              ),
              SizedBox(width: 20),
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
                      //overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      //maxLines: 2,
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          //check if it is on the top of the unloading list
                          if(unloadingDelivery.deliveryStatus=='On Route'){
                            UnloadingDelivery? theNextDelivery = null;
                            String nextDeliveryId = '';
                            if(unloadingDeliveries.length-1 != index){
                              theNextDelivery = unloadingDeliveries[index+1];
                              nextDeliveryId = theNextDelivery.unloadingId;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>UnloadingDeliveryReport(
                                unloadingDelivery: unloadingDelivery,
                                deliveryId: userAssignedSchedule, nextDeliveryId: nextDeliveryId,
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
                                              child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      FaIcon(FontAwesomeIcons.boxesPacking,
                                                      size: 40,color: Colors.green ),
                                                      Text(
                                                        'Delivery ${unloadingDelivery.unloadingId}',
                                                        textAlign: TextAlign.center, // Align text to the center
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.green
                                                        ),
                                                      ),
                                                      Text(
                                                        'already delivered',
                                                        textAlign: TextAlign.center, // Align text to the center
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.black
                                                        ),
                                                      ),
                                                    ]
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
                          else if(unloadingDelivery.deliveryStatus=="Halted"){
                            showHalted(unloadingDelivery.unloadingId);

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
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );

  }

  void showHalted(String deliveryId){
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
                          padding: EdgeInsets.all(10),
                          color: Colors.transparent,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.laptop,
                                    size: 40,color: Color(0xFF3871C1) ),
                                Text(
                                  'Delivery ${deliveryId}',
                                  textAlign: TextAlign.center, // Align text to the center
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3871C1)
                                  ),
                                ),
                                Text(
                                  'halted by management',
                                  textAlign: TextAlign.center, // Align text to the center
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                  ),
                                ),
                              ]
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



}




