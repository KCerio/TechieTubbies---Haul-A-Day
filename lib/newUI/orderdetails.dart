import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/newUI/components/assignDialog.dart';
import 'package:haul_a_day_web/newUI/components/deliveryReports.dart';
import 'package:haul_a_day_web/newUI/components/sidepanel.dart';
import 'package:haul_a_day_web/page/orderscreen.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String,dynamic> order;
  final TabSelection previousTab;
  OrderDetailsPage({super.key, required this.order, required this.previousTab});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String,dynamic> _order = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _order = widget.order;
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
                  flex: 6,
                  child: LayoutBuilder(
                    builder: (context,constraints) {
                      return Container(
                        //height: 1060,
                        padding:EdgeInsets.fromLTRB(16, 16, 16, 0),
                        //color: Color.fromARGB(109, 223, 222, 222),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: 1300, // Limit the height of SingleChildScrollView
                            child: Column(
                              children: [
                                Container(
                                  //padding:EdgeInsets.all(16),
                                  height: 600,
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
                                      SizedBox(height:16),
                                      Container(
                                        padding:EdgeInsets.all(16),
                                        height: 400,
                                        //color: Colors.white,
                                        child: orderInfo(_order)
                                      ),
                                    ],
                                  )
                                ),
                                SizedBox(height:16),
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
                  child: Container(color: Colors.green[200]),
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
                          builder: (_) => AlertDialog(
                            title: const Text("Error"),
                            content: const Text("Order Already Confirmed!"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      
                    } 
                    : () {
                        setState(() {
                          confirm = true;
                          order['confirmed_status'] = true; // Set the flag to true when the button is clicked
                        });
                        databaseService.updateConfirmValue(confirm, order['id']);
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
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
                          ),
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
                        builder: (_) => AlertDialog(
                          title: const Text("Alert"),
                          content: const Text("Do you wish to cancel confirmation or remove the order completely?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  confirm = !confirm;
                                  order['confirmed_status'] = confirm;
                                  order['assignedStatus'] = 'false'; 
                                });
                                databaseService.updateConfirmValue(confirm, order['id']);
                                if(order['assignedStatus'] == 'true'){
                                  databaseService.cancelSchedule(order['id'], order['assignedTruck']);
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
                        ),
                      );                      
                    } 
                    : (){                   
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
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
                      ),
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
                  onPressed: (){
                    if(order['assignedStatus'] == 'true' && order['confirmed_status'] == true){
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
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
                          ),
                        );
                    } else if(order['assignedStatus'] == 'false' && order['confirmed_status'] == true){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            content: AssignDialog(order: order,),
                          );
                        },
                      );
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

  Widget orderInfo(Map<String, dynamic> order){
    return Column(
      children: [
        Expanded(child: UnloadingSchedule(orderId: order['id']))
      ],
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
}