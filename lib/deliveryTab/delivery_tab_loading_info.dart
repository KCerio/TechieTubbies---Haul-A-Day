import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import '../components/bottomTab.dart';
import '../components/data/delivery_information.dart';
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
      backgroundColor: Colors.blue[700],
      body:Stack(
        children: [
          //white
          Positioned(
            bottom: 0,
            top:MediaQuery.of(context).size.height * 0.15,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50.0),
                  bottom: Radius.zero,
                ),
                color: Colors.white,
              ),
              //
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              30), // Adjust the padding values as needed
                          child: Text(
                            'Cargo Details',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(0, 15, 20, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 10),
                                  Icon(Icons.content_paste_search,
                                      size: 30, color: Colors.blue[700]),
                                  SizedBox(width: 10),
                                  Text(
                                    'cargo type',
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 16),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                widget.loadingDelivery.cargoType,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 80,
                          right: 80,
                          bottom: 0,
                          child: Container(
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(0, 15, 20, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(FontAwesomeIcons.boxOpen,
                                  size: 30, color: Colors.blue[700]),
                              SizedBox(width: 10),
                              Text(
                                'total cartons',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 16),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            '${widget.loadingDelivery.totalCartons} cartons',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              30), // Adjust the padding values as needed
                          child: Text(
                            'Time and Date',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.date_range_outlined,
                                  size: 30, color: Colors.blue[700]),
                              SizedBox(width: 10),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              intoTime(widget.loadingDelivery.loadingTimeDate),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'at',
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 16),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              intoDate(widget.loadingDelivery.loadingTimeDate),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              30), // Adjust the padding values as needed
                          child: Text(
                            'Location',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 10),
                                  Icon(Icons.warehouse_outlined,
                                      size: 30, color: Colors.blue[700]),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'warehouse',
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 16),
                                      ),
                                      Container(
                                        width:
                                        250, // Set the width of the container
                                        child: Text(
                                          widget.loadingDelivery.warehouse,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines:
                                          null, // Allow unlimited number of lines
                                          overflow: TextOverflow
                                              .clip, // Clip overflowed text
                                          softWrap:
                                          true, // Enable text wrapping
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 80, // Adjust this value to position the border
                          right: 80, // Adjust this value to position the border
                          bottom: 0,
                          child: Container(
                            height: 1.0, // Height of the border
                            color: Colors.grey[300], // Color of the border
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.location_on_outlined,
                                  size: 30, color: Colors.blue[700]),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'location',
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 16),
                                  ),
                                  Container(
                                    width:
                                    250, // Set the width of the container
                                    child: Text(
                                      widget.loadingDelivery.loadingLocation,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true, // Enable text wrapping
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //delivery id and loading cube
          Positioned(
            top: 0,
            left: 30,
            right: 30,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical:20),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 2, // Blur radius
                    offset: Offset(0, 3), // Offset
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (widget.loadingDelivery.deliveryStatus == 'Loaded!')
                            ? Icons.check_circle_rounded
                            : Icons.timer,
                        size: 100,
                        color: (widget.loadingDelivery.deliveryStatus == 'Loaded!')
                            ? Colors.blue[700]
                            : Colors.grey[400], // Adjust the size of the icon as needed
                        // Adjust the color of the icon
                      ),
                      Text(
                        widget.loadingDelivery.deliveryStatus,
                        style: TextStyle(
                          color: (widget.loadingDelivery.deliveryStatus == 'Loaded!')
                              ? Colors.blue[700]
                              : Colors.grey[400],
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Container(
                    //width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ORDER ${widget.deliveryId}',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          child: Text(
                            'Loading ${widget.loadingDelivery.loadingId}',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
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

