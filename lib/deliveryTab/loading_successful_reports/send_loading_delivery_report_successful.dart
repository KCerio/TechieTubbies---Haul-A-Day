

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';


import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';
import 'package:haul_a_day_mobile/deliveryTab/loading_successful_reports/loading_delivery_report_successful.dart';
import 'package:haul_a_day_mobile/deliveryTab/loading_successful_reports/upload_loading_success.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../bottomTab.dart';

class SendLoadingSuccess extends StatefulWidget {

  final LoadingDelivery loadingDelivery;
  final String orderId;
  final List<teamMember> team;
  final Timestamp arrivalTimeAndDate;
  final bool completeCartons;
  final String reasonIncomplete;
  final String recipientName;
  final XFile signatory;
  final XFile documentation;
  final Timestamp departureTimeAndDate;

  const SendLoadingSuccess({Key? key,
    required this.loadingDelivery,
    required this.orderId,
    required this.team,
    required this.arrivalTimeAndDate,
    required this.completeCartons,
    required this.reasonIncomplete,
    required this.recipientName,
    required this.signatory,
    required this.documentation,
    required this.departureTimeAndDate}) : super(key: key);

  @override
  _SendLoadingSuccessState createState() =>
      _SendLoadingSuccessState();
}



class _SendLoadingSuccessState extends State<SendLoadingSuccess> {
  int _currentIndex = 1;
  int progress = 90;






  @override
  void initState() {
    super.initState();
    initializeData(); // Call the method to initialize data
  }

  Future<void> initializeData() async {
    setState(() {}); // Call setState to update the UI after data is fetched
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: Text(
            'Create Successful Delivery Report',
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
                MaterialPageRoute(builder: (context) => DeliveryTab()),
              );
            },
          ),
        ),
        body: Column(
          children: [
            //progress bar
            Container(
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 20,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[900]!),
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

                  //loading Information
                  loadingInformation(),
                  SizedBox(height: 15),

                  informationContainer('Arrival Time and Date',
                      '${intoTime(widget.arrivalTimeAndDate)} at ${intoDate(widget.arrivalTimeAndDate)}'),
                  
                  informationContainer('Truck Team', teamNames(widget.team)),

                  informationContainer('Cartons', '${widget.loadingDelivery.totalCartons} cartons loaded'),

                  if(!widget.completeCartons)
                  informationContainer('Reason for Incomplete Cartons',
                      widget.reasonIncomplete),
                  
                  informationContainer('Recipient Name', widget.recipientName),

                  informationContainer('Signatory', widget.signatory.name),

                  informationContainer('Documentation', widget.documentation.name),

                  informationContainer('Departure Time and Date'
                      ,'${intoTime(widget.departureTimeAndDate)} at ${intoDate(widget.departureTimeAndDate)}'),






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
                                // return light blue when pressed
                                return Colors.blue[700]!;
                              }
                              // return blue when not pressed
                              return Colors.blue[200]!;
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
                            progress+=10;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UploadLoadingSucc(
                              loadingDelivery: widget.loadingDelivery,
                              orderId: widget.orderId,
                              team: widget.team,
                              arrivalTimeAndDate: widget.arrivalTimeAndDate,
                              completeCartons: widget.completeCartons,
                              reasonIncomplete: widget.reasonIncomplete,
                              recipientName: widget.recipientName,
                              signatory: widget.signatory,
                              documentation: widget.documentation,
                              departureTimeAndDate: widget.departureTimeAndDate)));



                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                // return light blue when pressed
                                return Colors.blue[700]!;
                              }
                              // return blue when not pressed
                              return Colors.blue[200]!;
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

  Widget loadingInformation(){
    return Container(
      color: Colors.blue[100],
      child: Column(
        children: [
          //orderId
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  'Order ID',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  widget.orderId,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          //deliveryId
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  'Delivery ID',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  widget.loadingDelivery.loadingId,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          //loadingTime
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  'Loading Time',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  intoTime(widget.loadingDelivery.loadingTimeDate),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          //loadingDate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  'Loading Date',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  intoDate(widget.loadingDelivery.loadingTimeDate),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          //loading Warehouse
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  'Loading Warehouse',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  widget.loadingDelivery.warehouse,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          //loading Location
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  'Location',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  widget.loadingDelivery.loadingLocation,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          //CargoType
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  'Cargo Type',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  widget.loadingDelivery.cargoType,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          //Total Cartons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  'Total Cartons',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                    10.0), // Adjust the padding values as needed
                child: Text(
                  widget.loadingDelivery.totalCartons.toString(),
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
    );
  }

  Widget informationContainer(String Title, String information){
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(
                  10.0), // Adjust the padding values as needed
              child: Text(
                Title,
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
                  information,
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

  String teamNames (List<teamMember> selected){
    return selected.map((member) => member.fullname).join(', ');
  }





}

