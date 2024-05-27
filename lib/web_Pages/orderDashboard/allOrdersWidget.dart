import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/web_Pages/otherComponents/sidepanel.dart';
import 'package:provider/provider.dart';

class AllOrders extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;
  AllOrders({super.key, required this.orderDetails});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {

  List<Map<String, dynamic>> _orderDetails =[];

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    setState(() {
      _orderDetails = widget.orderDetails;
    });
  }
  @override
  Widget build(BuildContext context) {
    //print("Orders: $widget.orderDetails");
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //thy list creates the containers for all the trucks
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // you can try to delete this
              itemCount: _orderDetails.length,
              itemBuilder: (context, index) {
                return orderContainer(_orderDetails[index]);
              },
            ),
          ],
        )
      ),
    );
  }

  Widget orderContainer(Map<String, dynamic> order,){
    //print('${order['id']}: ${order['assignedStatus'].runtimeType} ${order['confirmed_status'].runtimeType }');
    return Padding(
      padding: const EdgeInsets.only(right: 16,left:10),
      child: InkWell(
        onTap: () {
          Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedOrder(order);
          Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedTab(TabSelection.OrderDetails);
        },
        child: Container(
          height: 60,
          decoration: const BoxDecoration(
              //color: Color.fromARGB(255, 211, 208, 208), 
              border: Border( // Adding a border
                bottom: BorderSide(color: Color.fromARGB(181, 158, 158, 158), // Border color
                width: 1.0,),// Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: const Offset(0, 2), // Offset from the avatar
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: order['assignedStatus'] == 'true' && order['confirmed_status'] == true ? Color.fromRGBO(12, 197, 42, 0.74) 
                    : order['assignedStatus'] == 'false' && order['confirmed_status'] == true ? Color.fromRGBO(255, 213, 77, 0.8)
                    : Color.fromRGBO(35 , 99, 237, 0.67),
                    child: Icon(Icons.assignment, color: Colors.white, size: 35,),
                  ),
                ),

                const SizedBox(width: 10,),
                
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${order['id']} - ${order['route']}",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),  
                        ), // User's Fullname
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Text(
                                "Customer: ${order['company_name']}",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Text(
                                "Cargo Type: ${order['cargoType']}",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Text(
                                "Quantity: ${order['totalCartons']} ctns",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Text(
                                "Weight: ${order['totalWeight']} kg",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Text(
                                "Date Filed: ${order['filed_date']}",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}