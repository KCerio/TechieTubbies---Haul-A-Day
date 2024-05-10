

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';
import 'package:haul_a_day_mobile/deliveryTab/unsuccessful_reports/upload_report.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../components/bottomTab.dart';
import '../../components/data/delivery_information.dart';
import '../../components/data/teamMembers.dart';
import '../../components/dateThings.dart';



class SendUnsuccessfulReport extends StatefulWidget {

  final String deliveryId;
  final String orderId;
  final List<teamMember> team;
  final Timestamp TimeAndDate;
  final XFile documentation;
  final String reason;
  final String reasonSpec;

  const SendUnsuccessfulReport({Key? key,
    required this.deliveryId,
    required this.orderId,
    required this.team,
    required this.documentation,
    required this.TimeAndDate,
    required this.reason,
    required this.reasonSpec,
  }) : super(key: key);

  @override
  _SendUnsuccessfulReportState createState() =>
      _SendUnsuccessfulReportState();
}

class _SendUnsuccessfulReportState extends State<SendUnsuccessfulReport> {
  int _currentIndex = 1;
  int progress = 90;

  LoadingDelivery? loadingDelivery=null;
   UnloadingDelivery? unloadingDelivery=null;

  @override
  void initState() {
    super.initState();
    initializeData(); // Call the method to initialize data
  }

  Future<void> initializeData() async {
    retrieveDeliveryInformation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create Unsuccessful Delivery',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Report',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
        body: (loadingDelivery==null && unloadingDelivery==null)?
            Center(child: CircularProgressIndicator(color: Colors.blue[700],),)
        :Column(
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
                  deliveryInformation(),

                  SizedBox(height: 15),

                  informationContainer('Time and Date',
                      '${intoTime(widget.TimeAndDate)} at ${intoDate(widget.TimeAndDate)}'),

                  informationContainer('Truck Team', teamNames(widget.team)),

                  informationContainer('Reason of Unsuccessful Delivery', '${widget.reason}'),

                  if(widget.reason=='Others')
                    informationContainer('Specified Reason',
                        widget.reasonSpec),

                  informationContainer('Documentation', widget.documentation.name),



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
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  UploadUnsuccessfulReport(
                              deliveryId: widget.deliveryId,
                              orderId: widget.orderId,
                              team: widget.team,
                              documentation: widget.documentation,
                              TimeAndDate: widget.TimeAndDate,
                              reason: widget.reason,
                              reasonSpec: widget.reasonSpec)));



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


  Widget deliveryInformation()  {
    if(widget.deliveryId.startsWith('L')){
      return loadingInformation(loadingDelivery!);
    }else{
      return unloadingInformation(unloadingDelivery!);
    }

  }

  Future<void> retrieveDeliveryInformation() async{
    if(widget.deliveryId.startsWith('L')){

      loadingDelivery = (await retrieveLoadingDelivery(widget.orderId))! as LoadingDelivery?;

    }else{
      unloadingDelivery= (await retrieveUnloadingDelivery(widget.orderId, widget.deliveryId)) as UnloadingDelivery?;
    }

    setState(() {

    });

  }


  Widget unloadingInformation(UnloadingDelivery unloadingDelivery){
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
                  unloadingDelivery.unloadingId,
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
                  'Unloading Time',
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
                  intoTime(unloadingDelivery.unloadingTimeDate),
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
                  'Unloading Date',
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
                  intoDate(unloadingDelivery.unloadingTimeDate),
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
                  'Recipient',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible( // Wrap the Text widget with Flexible
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    unloadingDelivery.recipient,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                  unloadingDelivery.unloadingLocation,
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
                  'Quantity',
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
                  '${unloadingDelivery.quantity} cartons',
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
                  'Weight',
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
                  '${unloadingDelivery.weight} kgs',
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

  Widget loadingInformation(LoadingDelivery loadingDelivery){
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
                  widget.deliveryId,
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
                  intoTime(loadingDelivery.loadingTimeDate),
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
                  intoDate(loadingDelivery.loadingTimeDate),
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
              Flexible( // Wrap the Text widget with Flexible
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    loadingDelivery.warehouse,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                  loadingDelivery.loadingLocation,
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
                  loadingDelivery.cargoType,
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
                  loadingDelivery.totalCartons.toString(),
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

