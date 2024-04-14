import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../bottomTab.dart';
import 'delivery_tab.dart';


class LoadingInformation extends StatefulWidget {
  final LoadingDelivery loadingDelivery;
  final String deliveryId;

  const LoadingInformation({
    Key? key,
    required this.loadingDelivery,
    required this.deliveryId,
  }) : super(key: key);

  @override
  _LoadingInformationState createState() => _LoadingInformationState();
}

class _LoadingInformationState extends State<LoadingInformation> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        automaticallyImplyLeading: false,
        title: Text(
          'Delivery Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
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
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.blue[100],
      body:ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Center(
              child: Column(
                  children: [
                    Container(
                      height: 90,
                      width: double.infinity, // Fill the width of its parent
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 3, // Blur radius
                            offset: Offset(0, 2), // Shadow offset
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.deliveryId,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            widget.loadingDelivery.loadingId,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 350,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          //loading time
                          Container(
                            width: 350,
                            color: Colors.grey[300],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Loading Time:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  intoTime(widget.loadingDelivery.loadingTimeDate),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          //loading date
                          Container(
                            width: 350,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Loading Date:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  intoDate(widget.loadingDelivery.loadingTimeDate),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          //loading type
                          Container(
                            width: 350,
                            color: Colors.grey[300],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Cargo Type:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  widget.loadingDelivery.cargoType,
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          //loading warehouse
                          Container(
                            width: 350,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Warehouse:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Flexible(child: Text(
                                  widget.loadingDelivery.warehouse,
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),)
                              ],
                            ),
                          ),

                          //loading location
                          Container(
                            width: 350,
                            color: Colors.grey[300],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Loading Location:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Flexible(child: Text(
                                  widget.loadingDelivery.loadingLocation,
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),)
                              ],
                            ),
                          ),

                          //loading cartons
                          Container(
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Total Cartons:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  widget.loadingDelivery.totalCartons.toString(),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),



                        ],
                      ),
                    ),
                  ]
              )

          ),
        ],
      ),
      bottomNavigationBar: BottomTab(currIndex: _currentIndex)

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

