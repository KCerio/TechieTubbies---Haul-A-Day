import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:haul_a_day_mobile/truckTeamTab/truckteam_tab.dart';
import 'package:intl/intl.dart';
import '../accountTab/account_tab.dart';
import '../bottomTab.dart';
import 'delivery_tab.dart';


class UnloadingInformation extends StatefulWidget {
  final UnloadingDelivery unloadingDelivery;
  final String deliveryId;

  const UnloadingInformation({
    Key? key,
    required this.unloadingDelivery,
    required this.deliveryId,
  }) : super(key: key);

  @override
  _UnloadingInformationState createState() => _UnloadingInformationState();
}

class _UnloadingInformationState extends State<UnloadingInformation> {
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
                            widget.unloadingDelivery.unloadingId,
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
                          //unloading time
                          Container(
                            width: 350,
                            color: Colors.grey[300],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Unloading Time:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  intoTime(widget.unloadingDelivery.unloadingTimeDate),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          //unloading date
                          Container(
                            width: 350,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Unloading Date:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  intoDate(widget.unloadingDelivery.unloadingTimeDate),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          //unloading refnum
                          Container(
                            width: 350,
                            color: Colors.grey[300],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Reference Number:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  widget.unloadingDelivery.referenceNum.toString(),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          //unloading recipient
                          Container(
                            width: 350,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recipient:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.unloadingDelivery.recipient,
                                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //loading location
                          Container(
                            width: 350,
                            color: Colors.grey[300],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Unloading Location:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Flexible(child: Text(
                                  widget.unloadingDelivery.unloadingLocation, overflow: TextOverflow.clip,
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),)
                              ],
                            ),
                          ),

                          //loading quantity
                          Container(
                            width: 350,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Quantity:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  widget.unloadingDelivery.quantity.toString(),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          //unloading weight
                          Container(
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35), // Add horizontal padding for space between text and edges
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end of the row
                              children: [
                                Text(
                                  'Weight:',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  '${widget.unloadingDelivery.weight.toString()} kgs',
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