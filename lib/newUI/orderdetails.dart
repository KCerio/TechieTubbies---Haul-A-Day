import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/newUI/components/dialogs/assignDialog.dart';
import 'package:haul_a_day_web/newUI/components/deliveryReports.dart';
import 'package:haul_a_day_web/newUI/components/sidepanel.dart';
import 'package:haul_a_day_web/page/orderscreen.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String,dynamic> order;
  final TabSelection previousTab;
  OrderDetailsPage({super.key, required this.order, required this.previousTab});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String,dynamic> _order = {};
  List<Map<String, dynamic>> _unloadings = [];
  List<Map<String, dynamic>> _deliveryReport = [];
  List<Map<String, dynamic>> _truckteam = [];
  DatabaseService databaseService = DatabaseService();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _order = widget.order;
    getUnloadings();
  }

  Future<void> getUnloadings()async{
    List<Map<String, dynamic>> unloadings = await databaseService.fetchUnloadingSchedules(_order['id']);
    List<Map<String, dynamic>> deliveryReport = await databaseService.fetchDeliveryReports(_order['id']);
    List<Map<String, dynamic>> truckteam = await databaseService.fetchTruckTeam(_order['id']);
    //print("Delivery Reports: $deliveryReport");
    //print("Unloadings: $unloadings");
    setState(() {
      _unloadings=unloadings;
      _deliveryReport = deliveryReport;
      _truckteam = truckteam;
    });
  }

 
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      width: double.infinity,
      
      child: Column(
        children: [
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                  onPressed: (){
                    if(widget.previousTab == TabSelection.Order){
                    Provider.of<SideMenuSelection>(context, listen: false)
                      .setSelectedTab(TabSelection.Order); // Assuming the order tab index is 3
                    }else if(widget.previousTab == TabSelection.Delivery){
                      Provider.of<SideMenuSelection>(context, listen: false)
                      .setSelectedTab(TabSelection.Delivery);
                    }
                  },
                  icon: Icon(Icons.arrow_back, size: 30)
                ),
                SizedBox(width: 10,),
                const Text(
                  'Order Details',
                  style: TextStyle(
                    fontFamily: 'Itim',
                    fontSize: 36
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: LayoutBuilder(
                    builder: (context,constraints) {
                      
                      return Container(
                        //height: 1060,
                        padding:EdgeInsets.fromLTRB(16, 16, 16, 0),
                        //color: Color.fromARGB(109, 223, 222, 222),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: 1650, // Limit the height of SingleChildScrollView
                            child: Column(
                              children: [
                                Container(
                                  //padding:EdgeInsets.all(16),
                                  height: 850,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      //Order Details
                                      Container(
                                        padding: EdgeInsets.fromLTRB(50, 16, 16, 16),
                                        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.green[300],
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5), // Shadow color
                                              spreadRadius: 5, // Spread radius
                                              blurRadius: 5, // Blur radius
                                              offset: Offset(0, 3), // Offset from the container
                                            ),
                                          ],
                                        ),
                                        child: orderTitle(_order)
                                      ),
                                      //SizedBox(height:16),
                                      Container(
                                        //padding:EdgeInsets.all(16),
                                        height: 700,
                                        //color: Colors.yellow,
                                        child: orderInfo(_order, _truckteam, _unloadings)
                                      ),
                                    ],
                                  )
                                ),
                                SizedBox(height:16),

                                //Customer Details
                                Container(
                                  height: 115,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: customerDetails(widget.order)
                                ),
                                SizedBox(height:16),

                                //Delivery Reports
                                Container(
                                  padding: EdgeInsets.all(16),
                                  height: 500,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                      padding: const EdgeInsets.only(bottom: 10),
                                       alignment: Alignment.centerLeft,
                                       child: const Text(
                                         'Delivery Reports',
                                         style: TextStyle(
                                           fontFamily: 'Inter',
                                           fontSize: 26,
                                           fontWeight: FontWeight.bold
                                         ),
                                       ),
                                     ),
                                     
                               
                                      const Divider(color: Colors.blue,),
                            
                                      Container(
                                        //padding: const EdgeInsets.only(top: 10),
                                        width: double.infinity,
                                        height: 400,
                                        child:  DeliveryReports(order: widget.order,)
                                      )
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                        );
                    }
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: LayoutBuilder(
                      builder: (context,constraints) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey), // Create a simple border
                              borderRadius: BorderRadius.circular(10), // Define border radius
                            ),
                            child: (_unloadings.isEmpty)
                                ?Container(
                                  height: constraints.maxHeight,
                                  child: Center(
                                    child: CircularProgressIndicator(color: Colors.green[700],),
                                  ),
                                )
                                :Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Status',
                                  style: TextStyle(
                                    fontFamily: 'Itim',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                orderStatus(constraints),
                                SizedBox(height:20),
                                completeDelivery(),


                              ],
                            ),
                          ),
                        );
                      }
                  ),
                )
              ],
            ) 
            
          )
        ],
      ),
    );
  }

  Widget orderTitle(Map<String, dynamic> order){
    DatabaseService databaseService = DatabaseService();
    bool confirm = order['confirmed_status'];
    BuildContext dialogContext;
    print('${order['id']}: $confirm ${order['assignedStatus']}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Order title and filed date & time
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${order['id']} - ${order['route']}',
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${order['filed_date']} at ${order['filed_time']}',
              style: TextStyle(
                fontFamily: 'Iter',
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),

        // Confirm & cancel and Assign buttons
        Column(
          children: [
            //confirm and cancel butttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: confirm
                  ? (){
                    // Button is disabled if order is already confirmed
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        dialogContext = context; // Store the context
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Order Already Confirmed!"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop(); // Use the stored context to pop the dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      }
                    );
                  } 
                  : () {
                    setState(() {
                      DateTime timestamp = DateTime.now();
                      String timestampString = timestamp.toIso8601String(); // Convert DateTime to string
                      confirm = true;
                      order['confirmed_status'] = true; // Set the flag to true when the button is clicked
                      order['confirmedTimestamp'] = timestampString;
                    });
                    databaseService.updateConfirmValue(confirm, order['id']);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        dialogContext = context; // Store the context
                          return AlertDialog(
                          title: const Text("Confirmation"),
                          content: const Text("Order confirmed!"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      }
                    );                                         
                  }, 
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('Confirm', style: TextStyle(color: Colors.white))
                    ],
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    backgroundColor: confirm
                        ? MaterialStateProperty.all<Color>(Colors.grey) // Gray out the button if confirmed
                        : MaterialStateProperty.all<Color>(Colors.amber),
                    foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: confirm
                    ? (){
                      // Button is disabled if order is already confirmed
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                        dialogContext = context; // Store the context
                          return AlertDialog(
                            title: const Text("Alert"),
                            content: const Text("Do you wish to cancel confirmation or remove the order completely?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    confirm = !confirm;
                                    order['confirmed_status'] = confirm;
                                    order['confirmedTimestamp'] = null;
                                  });
                                  databaseService.updateConfirmValue(confirm, order['id']);
                                  if(order['assignedStatus'] == 'true'){
                                    databaseService.cancelSchedule(order['id'], order['assignedTruck']);
                                    setState(() {    
                                      order['assignedStatus'] = 'false'; 
                                      order['assignedTimestamp'] = null;
                                    });
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel Confirmation'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Remove Order'),
                              ),
                            ],
                          );
                        },
                      );                      
                    } 
                    : (){                   
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        dialogContext = context; // Store the context
                        return AlertDialog(
                        title: const Text("Alert"),
                        content: const Text("Do you wish to cancel confirmation or remove the order completely?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Remove Order'),
                          ),
                        ],
                      );
                      }
                    );
                  }, 
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('Cancel', style: TextStyle(color: Colors.white))
                    ],
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(233, 98, 105,1)),
                    //foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: ()async{
                    if(order['assignedStatus'] == 'true' && order['confirmed_status'] == true){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                        dialogContext = context; // Store the context
                        return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("Order Already Assigned!"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                          }
                        );
                    } else if(order['assignedStatus'] == 'false' && order['confirmed_status'] == true){
                      // Show the AssignDialog and wait for it to complete
                      String? assigned = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            content: AssignDialog(order: order, onAssigned: (value) {
                              Navigator.of(context).pop(value); // Close the dialog and return the assigned value
                            },),
                          );
                        },
                      );
                      print('AssignS: $assigned');
                      // Now that the dialog has finished, get the assigned truck ID
                      if (assigned != null && assigned.isNotEmpty) {
                        DateTime timestamp = DateTime.now();
                        String timestampString = timestamp.toIso8601String(); // Convert DateTime to string

                        setState(() {
                          order['assignedStatus'] = 'true';
                          order['assignedTimestamp'] = timestampString; // Add timestamp as a string to the map
                        });
                      }

                    } else if(order['assignedStatus'] == 'false' && order['confirmed_status'] == false){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("Order Not Confirmed!"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }, 
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping_rounded, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('Assign', style: TextStyle(color: Colors.white))
                    ],
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(98, 123, 247, 1)),
                    //foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget orderInfo(Map<String, dynamic> order, List<Map<String, dynamic>> truckteam, List<Map<String, dynamic>> _unloadings){
    String driver = ' ';
    String Helper1 = ' ';
    String Helper2 = ' ';
    int count = 0;
    for (Map<String, dynamic> crew in truckteam){
      if(crew['position'] == 'Driver'){
        driver = crew['name'];
      } else if(crew['position'] == 'Helper'){
        count++;
        if(count == 1){
          Helper1 = crew['name'];
        }else if(count == 2){
          Helper2 = crew['name'];
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 16, 35, 24),
      child: Column(
        children: [
          //Loading Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: LayoutBuilder(
              builder: (context,constraints) {
                double width = constraints.maxWidth;
                print("width: $width" );
                return Container(
                  //color: Colors.yellow,
                  height: 125,
                  child: Row(                        
                    children: [
                      //Loading Info
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        //padding: EdgeInsets.fromLTRB(0, 10, 100, 10),
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.grey),
                        //   borderRadius: BorderRadius.circular(15)
                        // ),
                        //color: Colors.brown,
                        width: width/2 -8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Loading Schedule Information',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                //fontFamily: 'InriaSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green
                              )
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: const Text(
                                      'Cargo Type',
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(115, 115, 115, 1)
                                      )
                                    ),
                                  ),
                                  //const SizedBox(width: 50,),
                                  Container(
                                    width: (width/2)/2,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Text(
                                      order['cargoType'],
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: const Text(
                                      'Warehouse',
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:  Color.fromRGBO(115, 115, 115, 1)
                                      )
                                    ),
                                  ),
                                  //const SizedBox(width: 50,),
                                  Container(
                                    width: (width/2)/2,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Text(
                                      order['warehouse'],
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: const Text(
                                      'Location',
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(115, 115, 115, 1)
                                      )
                                    ),
                                  ),
                                  //const SizedBox(width: 20,),
                                  Container(
                                    width: (width/2)/2,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Text(
                                      order['loadingLocation'],
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: const Text(
                                      'Date & Time',
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(115, 115, 115, 1)
                                      )
                                    ),
                                  ),
                                  //const SizedBox(width: 20,),
                                  Container(
                                    width: (width/2)/2,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Text(
                                      '${order['loadingDate']} at ${order['loadingTime']}',
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      
                      VerticalDivider(),
                      // Delivery Information
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //padding: EdgeInsets.fromLTRB(0, 10, 100, 10),
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.grey),
                        //   borderRadius: BorderRadius.circular(15)
                        // ),
                        //color: Colors.brown,
                        width: width/2 -16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Delivery Information',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                //fontFamily: 'InriaSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green
                              )
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    padding: EdgeInsets.only(left: 50),
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: const Text(
                                      'Route',
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(115, 115, 115, 1)
                                      )
                                    ),
                                  ),
                                  //const SizedBox(width: 20,),
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Text(
                                      order['route'],
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    padding: EdgeInsets.only(left: 50),
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: const Text(
                                      'Driver',
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(115, 115, 115, 1)
                                      )
                                    ),
                                  ),
                                  //const SizedBox(width: 20,),
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Text(
                                     driver,
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    padding: EdgeInsets.only(left: 50),
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: const Text(
                                      'Helper',
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(115, 115, 115, 1)
                                      )
                                    ),
                                  ),
                                  //const SizedBox(width: 20,),
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Text(
                                      Helper1,
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: const Text(
                                      '',
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ),
                                  //const SizedBox(width: 20,),
                                  Container(
                                    width: (width/2 -16)/2-20,
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Text(
                                      Helper2,
                                      style: const TextStyle(
                                        //fontFamily: 'InriaSans',
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                );
              }
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: const Text(
              'Unloading Schedules',
              style: TextStyle(
                fontFamily: 'Iter',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green
              ),
            ),
          ),
          //Divider(),
          // Unloading Info
          Container(
            //color: Colors.blue,
            height: 300,
            child: unloadingList(_unloadings),
            //child: UnloadingSchedule(orderId: order['id'])
            // child: Expanded(
            //   child: Container(
            //     alignment: Alignment.topCenter,
            //     child: Scrollbar(
            //       thumbVisibility: true,
            //       child: SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: SingleChildScrollView(
            //             scrollDirection: Axis.vertical,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 DataTable(
            //                   showCheckboxColumn: false,
            //                   columns: const [
            //                     DataColumn(label: 
            //                     Expanded(
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.center, 
            //                         children: [Text('RECIPIENT', textAlign: TextAlign.start,style: TextStyle(color: Color.fromRGBO(115, 115, 115, 1)))]
            //                         )
            //                       )
            //                     ),
            //                     DataColumn(label: 
            //                     Expanded(
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.center, 
            //                         children: [Text('QUANTITY', textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(115, 115, 115, 1)))]
            //                         )
            //                       )
            //                     ),
            //                     DataColumn(label: 
            //                     Expanded(
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.center, 
            //                         children: [Text('WEIGHT', textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(115, 115, 115, 1)))]
            //                         )
            //                       )
            //                     ),                                
            //                     DataColumn(
            //                       label: Expanded(
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.center,
            //                           children: [Text('DELIVERY DATE', textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(115, 115, 115, 1)))]
            //                         )
            //                       )
            //                     ),
            //                     DataColumn(
            //                       label: Expanded(
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.center,
            //                           children: [Text('STATUS', textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(115, 115, 115, 1)))]
            //                         )
            //                       )
            //                     ),
            //                   ],
            //                   rows: _rows ?? [], // Populate rows with data
            //                 ),
            //               ],
            //             )
                      
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          
          ),
          //Divider(),
          //Notes and Total Weights & ctns
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: LayoutBuilder(
              builder: (context,constraints) {
                double width = constraints.maxWidth;
                print("width: $width" );
                return Container(
                  //color: Colors.yellow,
                  height: 125,
                  child: Row(                        
                    children: [
                      //Notes
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
                        padding: EdgeInsets.fromLTRB(0, 0, 100, 10),
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.grey),
                        //   borderRadius: BorderRadius.circular(15)
                        // ),
                        //color: Colors.brown,
                        width: width/2 -16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notes:',
                              style: TextStyle(
                                //fontFamily: 'InriaSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                //'Your long text goes here and will be wrapped within the container.',
                                order['note']?? '',
                                softWrap: true,
                                style: TextStyle(                                  
                                  fontSize: 14,
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      //
                      Container(
                        padding: EdgeInsets.fromLTRB(100, 0, 0, 10),
                        //color: Colors.yellow,
                        width: width/2,
                        child: Column(
                          children: [
                            //Total Cartons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Cartons:',
                                  style: const TextStyle(
                                    //fontFamily: 'InriaSans',
                                    fontSize: 18,
                                    //fontWeight: FontWeight.bold
                                  )
                                ),
                                const SizedBox(width: 50,),
                                Text(
                                  '${order['totalCartons'] ?? ''} ctns',
                                  style: const TextStyle(
                                    //fontFamily: 'InriaSans',
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(1, 119, 7, 1)
                                  )
                                )
                              ],
                            ),
            
                            const SizedBox(height: 8),
            
                            //Total weight
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Weight:',
                                  style: const TextStyle(
                                    //fontFamily: 'InriaSans',
                                    fontSize: 18,
                                    //fontWeight: FontWeight.bold
                                  )
                                ),
                                const SizedBox(width: 50,),
                                Text(
                                  '${order['totalWeight'] ?? ''} kgs',
                                  style: const TextStyle(
                                    //fontFamily: 'InriaSans',
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(1, 119, 7, 1)
                                  )
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            ),
          )
          
        ],
      ),
    );

  }

  Widget unloadingList(List<Map<String, dynamic>> _unloadings){
    return Column(
      children: [
        LayoutBuilder(
          builder: (context,constraints) {
            double width = constraints.maxWidth -140;
            print("width1: $width");
            return Container(
              margin: EdgeInsets.fromLTRB(50, 8, 50, 0),
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 30,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
                
              ),
              child: Row(
                children: [
                  Container(
                    width:width *(2/6),
                    child: Text(
                      'RECIPIENT',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    width:width *(1/6),
                    child: Text(
                      'REF NO.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width:width *(1/6),
                    child: Text(
                      'QUANTITY (CTN)',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width:width *(1/6),
                    child: Text(
                      'WEIGHT (KG)',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width:width *(1/6),
                    child: Text(
                      'DELIVERY DATE',
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            );
          }
        ),
                
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //thy list creates the containers for all the trucks
                
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                  itemCount: _unloadings.length,
                  itemBuilder: (context, index) {
                    return unloadinContainer(_unloadings[index]);
                  },
                ),
        
              ],
            )
          ),
        ),
      ],
    );

  }

  Widget unloadinContainer(Map<String,dynamic> unload){
    var date = unload['unloadingTimestamp'].toDate();
      String unloadDate = DateFormat('MMM dd, yyyy').format(date);
      String time = DateFormat('HH:mm a').format(date);

    return LayoutBuilder(
      builder: (context,constraints) {
        double width = constraints.maxWidth -140;
        print("width1: $width");
        return Container(
          margin: EdgeInsets.fromLTRB(50, 8, 50, 0),
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 50,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
            
          ),
          child: Row(
            children: [
              Container(
                width:width *(2/6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unload['recipient'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //SizedBox(height: 4), // Adjust the height as needed
                    
                    Text(
                      '${unload['unloadingLocation']} - ${unload['unloadId']}',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width:width *(1/6),
                child: Text(
                  unload['reference_num'].toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width:width *(1/6),
                child: Text(
                  unload['quantity'].toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width:width *(1/6),
                child: Text(
                  unload['weight'].toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width:width *(1/6),
                child: Text(
                  '$unloadDate \n$time',
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              
            ],
          ),
        );
      }
    );
  }

  Widget customerDetails(Map<String, dynamic> order){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Details:',
            ),
            Text(
              '${order['point_person']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            Text(
              '${order['company_name']}',
            ),
          ],
        ),
        SizedBox(width: 50,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${order['phone']}',
            ),
            Text(
              '${order['customer_email']}',
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Colors.green,
                color: Colors.green,
              ),
            ),
            Text(
              '${order['filed_date']} at ${order['filed_time']}',
            ),
          ],
        )
      ],
    );
  }

  Widget orderStatus(constraints) {
    Map<String, dynamic> loadReport = {};
    List<Map<String, dynamic>> unloadReport = [];
    for(Map<String, dynamic> report in  _deliveryReport){
      if(report['id'].contains('LS')){
        loadReport = report;
      }
      else if(report['id'].contains('US')){
        unloadReport.add(report);
      }
    }
    
    return SizedBox(
      height: constraints.maxHeight*0.77, // Constrain the height
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orderConfirmTile(constraints),
            assignTile(constraints),
            loadingTile(constraints,loadReport),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: _unloadings.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> unload = _unloadings[index];
                Map<String, dynamic> report = index < unloadReport.length ? unloadReport[index] : {};
                if(index==_unloadings.length-1){
                  return lastUnloadingTile(constraints, unload, report);
                }else{
                  return unloadingTile(constraints, unload,report);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget completeDelivery(){
    Map<String, dynamic> lastUnload = _unloadings[_unloadings.length-1];
    bool isComplete = lastUnload['deliveryStatus'] =='Delivered!';
    return Container(
        child: Row(
          children: [
            Icon(
              isComplete?Icons.check_circle:Icons.timer,
              color: isComplete? Colors.green[700]!:Colors.grey[700]!,),
            Text(
              isComplete? 'Order ${_order['id']} Completed!': 'Order ${_order['id']} In Progress...',
              style: TextStyle(
                color: isComplete? Colors.green[700]!:Colors.grey[700]!,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        )
    );
  }


  Widget orderConfirmTile(constraints){
    print('here');
    double tileheight =constraints.maxHeight *0.125;
    bool isConfirmed =_order['confirmed_status']==true;
    String? confirmedDate;
    if(_order['confirmedTimestamp'] != null){
      DateTime timestamp = DateTime.parse(_order['confirmedTimestamp']);
      confirmedDate = DateFormat('MMM dd, yyyy').format(timestamp);
    }
    print('Confirmed: $confirmedDate');
    return SizedBox(
      height: tileheight-6,
      child: TimelineTile(
        isFirst: true,
        endChild: statusContainer(
          isConfirmed ? "Order Confirmed" : "Order Not Yet Confirmed",
          confirmedDate ?? "Confirmation in progress", // Using null-aware operator to provide a default value
          isConfirmed,
        ),  
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isConfirmed ? Colors.blue[700]! : Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.assignment,
          ),
        ),
        afterLineStyle: LineStyle(
          color: isConfirmed ? Colors.blue[700]! : Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget assignTile(constraints){
    double tileheight =constraints.maxHeight *0.125;
    bool isAssigned = _order['assignedStatus']=='true';
    String? assignedDate;
    if(_order['assignedTimestamp'] != null){
      DateTime timestamp = DateTime.parse(_order['assignedTimestamp']);
      assignedDate = DateFormat('MMM dd, yyyy').format(timestamp);
    }
    print('Assigned: $assignedDate $isAssigned');
    return SizedBox(
      height:tileheight,
      child: TimelineTile(
        endChild: statusContainer(
            isAssigned? "Order Assigned - ${_order['assignedTruck']}": "Order Not Yet Assigned",
            assignedDate ?? "assignment in process",
            isAssigned? true: false),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isAssigned?Colors.blue[700]! : Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.local_shipping,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isAssigned?Colors.blue[700]! : Colors.grey[700]!,
          thickness: 6,
        ),
        afterLineStyle: LineStyle(
          color: isAssigned?Colors.blue[700]! : Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget loadingTile(constraints, Map<String, dynamic> load){
    //print('Loading: $load');
    double tileheight =constraints.maxHeight *0.125;
    bool isLoaded = _order['loadingStatus']=='Loaded!';
    bool isAssigned = _order['assignedStatus']=='true';
    String? departDate;
    //print('Load: ${load['departureTimeDate']}');
    if(isLoaded &&load['departureTimeDate'] != null){
      var departTimestamp = load['departureTimeDate'].toDate();
      departDate = DateFormat('MMM dd, yyyy').format(departTimestamp);
    }
    //print('Load: $departDate');

    return SizedBox(
      height:tileheight,
      child: TimelineTile(
        endChild: statusContainer(
            isLoaded? "${_order["loading_id"]} Loaded":
            (isAssigned? "Loading ${_order["loading_id"]}...": "Order Not Yet Assigned"),
            departDate ?? (isAssigned?"loading in progress":'order in progress'),
            isLoaded? true: false),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isLoaded?Colors.blue[700]!:Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData:  Icons.featured_video,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isLoaded?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
        afterLineStyle: LineStyle(
          color: isLoaded?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget unloadingTile(constraints, Map<String, dynamic> unload, Map<String, dynamic> report){
    double tileheight =constraints.maxHeight *0.125;

    bool isDelivered = unload['deliveryStatus']=='Delivered!';
    bool isAssigned = _order['assignedStatus']=='true';

    String? departDate;
    if(isDelivered && report['departureTimeDate'] != null){
      var departTimestamp = report['departureTimeDate'].toDate();
      departDate = DateFormat('MMM dd, yyyy').format(departTimestamp);
    }
    print('Unload: $departDate');
    return SizedBox(
      height:tileheight,
      child: TimelineTile(
        endChild: statusContainer(
          isDelivered? " ${unload['unloadId']} Delivered!":
          (isAssigned? '${unload['unloadId']}  ${unload['deliveryStatus']}': 'Order Not Yet Assigned'),
            departDate ?? (isAssigned?"delivery in progress":"order in progress"),
            isDelivered?true:false),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.featured_play_list_rounded,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
        afterLineStyle: LineStyle(
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget lastUnloadingTile(constraints, Map<String, dynamic> unload, Map<String, dynamic> report){
    double tileheight =constraints.maxHeight *0.125;

    bool isDelivered = unload['deliveryStatus']=='Delivered!';
    bool isAssigned = _order['assignedStatus']=='true';

    String? departDate;
    if(isDelivered && report['departureTimeDate'] != null){
      var departTimestamp = report['departureTimeDate'].toDate();
      departDate = DateFormat('MMM dd, yyyy').format(departTimestamp);
    }
    print('Last Unload: $departDate');
    return SizedBox(
      height:tileheight,
      child: TimelineTile(
        isLast: true,
        endChild: statusContainer(
            isDelivered? " ${unload['unloadId']} Delivered!":
            (isAssigned? '${unload['unloadId']}  ${unload['deliveryStatus']}': 'Order Not Yet Assigned'),
            departDate ?? (isAssigned?"delivery in progress":"order in progress"),
            isDelivered?true:false),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.featured_play_list_rounded,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
        afterLineStyle: LineStyle(
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget statusContainer(String title, String subtitle, bool stat){
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          child: Column( // Wrap Row with Column
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Center the contents vertically
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(subtitle,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    (stat) ? Icons.check_circle_outline_outlined : Icons.timer,
                    color: (stat) ? Colors.green[700] : Colors.grey[700],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}