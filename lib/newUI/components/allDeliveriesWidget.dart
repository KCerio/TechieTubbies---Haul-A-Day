import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/newUI/components/sidepanel.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:provider/provider.dart';

class AllDeliveries extends StatefulWidget {
  List<Map<String, dynamic>> orderDetails;
  AllDeliveries({super.key, required this.orderDetails});

  @override
  State<AllDeliveries> createState() => _AllDeliveriesState();
}

class _AllDeliveriesState extends State<AllDeliveries> {
  
  List<Map<String, dynamic>> _deliverySchedules =[];
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    for(Map<String, dynamic> order in widget.orderDetails){
      if(order['assignedStatus'] == 'true' && order['confirmed_status'] == true){
        _deliverySchedules.add(order);
      }
    }
  }

  //Future<void> status
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //thy list creates the containers for all the trucks
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _deliverySchedules.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Widget>(
                  future: deliveryContainer(_deliverySchedules[index]),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data ?? Container(); // Return the widget or an empty Container
                    }
                  },
                );
              },
            ),

          ],
        )
      ),
    );
  }

  Future<bool> getUnloadingStatus(String orderId)async{
    DatabaseService databaseService = DatabaseService();
    List<Map<String, dynamic>> unloadingSchedules = await databaseService.fetchUnloadingSchedules(orderId);
    List<Map<String, dynamic>> reports = await databaseService.fetchDeliveryReports(orderId);
    print('${(unloadingSchedules.length + 1)}  ${(reports.length)}');
    if(unloadingSchedules.isEmpty && reports.isEmpty){
      return false;
    }else if(unloadingSchedules.length + 1 == reports.length){
      return true;
    } return false;
  }



  Future<Widget> deliveryContainer(Map<String,dynamic> delivery)async{
    bool deliveryStatus = await getUnloadingStatus(delivery['id']);
    print('${delivery['id']}: $deliveryStatus');
    return Padding(
      padding: const EdgeInsets.only(right: 16,left:10),
      child: InkWell(
        onTap:(){
          Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedOrder(delivery);
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
                    backgroundColor: deliveryStatus == true ? Color.fromRGBO(12, 197, 42, 0.74)
                    : delivery['loadingStatus'] == 'Loaded!' ? Color.fromRGBO(255, 213, 77, 0.8)
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
                          "${delivery['id']} - ${delivery['route']}",
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
                                "Truck Team: ${delivery['assignedTruck']}",
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
                                "Customer: ${delivery['company_name']}",
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
                                "Cargo Type: ${delivery['cargoType']}",
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
                                "Quantity: ${delivery['totalCartons']} ctns",
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
                                "Weight: ${delivery['totalWeight']} kg",
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