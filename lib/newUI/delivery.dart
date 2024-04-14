import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/newUI/components/allDeliveriesWidget.dart';
import 'package:haul_a_day_web/newUI/orderdashboard.dart';

class DeliveryDashboard extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;
  final bool fetchOrderDetails;
  DeliveryDashboard({super.key, required this.orderDetails, required this.fetchOrderDetails});

  @override
  State<DeliveryDashboard> createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical:10),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    
                    child: const Text(
                      'Delivery Dashboard',
                      style: TextStyle(
                        fontFamily: 'Itim',
                        fontSize: 36
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 9,
              child: LayoutBuilder(
                 builder: (context,constraints) {
                   return widget.fetchOrderDetails == false ? const Center(child: CircularProgressIndicator(),)
                  :SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Column(
                             children: [
                               Container(
                                width: double.infinity,
                                height: 50,
                                 child: Row(
                                   children: [
                                     Container(
                                      padding: const EdgeInsets.only(bottom: 10),
                                       alignment: Alignment.centerLeft,
                                       child: const Text(
                                         'All Deliveries',
                                         style: TextStyle(
                                           fontFamily: 'Inter',
                                           fontSize: 26,
                                           fontWeight: FontWeight.bold
                                         ),
                                       ),
                                     ),
                                     const SizedBox(width: 20,),
                                     Container(child: labelButtons(),),
                                     const Spacer(flex: 2,),
                  
                                      //Search Bar
                                      Expanded(
                                        child: TextField(
                                          onChanged: (value){
                                            //_filterOrders(value);
                                          },
                                          decoration: const InputDecoration(
                                            fillColor: Color.fromARGB(109, 223, 222, 222),
                                            filled: true,
                                            hintText: "Search Delivery",
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                                            suffixIcon: Icon(Icons.search, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                   ],
                                 ),
                               ),

                               
                               const Divider(color: Colors.blue,),
                            
                               Container(
                                 width: double.infinity,
                                 height: 500,
                                 child:  AllDeliveries(orderDetails: widget.orderDetails)
                               )
                             ],
                           ),
                         ),
                      ],
                    ),
                  );
                }
              )
            )

          ],
        ),
      ),
    );
  }

  Widget labelButtons() {
  return Row(
    children: [
      HoverContainer(
        hoverColor: const Color.fromRGBO(35, 99, 237, 1),
        defaultColor: const Color.fromRGBO(35, 99, 237, 0.67),
        hoverText: 'Cargoes not yet Loaded',
        child: Container(
          width: 128,
          height: 25,
          margin: const EdgeInsets.all(5),
          child: const Center(
            child: Text(
              'Not Loaded',
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10,),
      HoverContainer(
        hoverColor: const Color.fromRGBO(255, 213, 77, 1),
        defaultColor: const Color.fromRGBO(255, 213, 77, 0.8),
        hoverText: 'Delivery in progress',
        child: Container(
          width: 128,
          height: 25,
          margin: const EdgeInsets.all(5),
          child: const Center(
            child: Text(
              'In Progress',
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10,),
      HoverContainer(
        hoverColor: const Color.fromRGBO(12, 197, 42, 1),
        defaultColor: const Color.fromRGBO(12, 197, 42, 0.74),
        hoverText: 'Delivery accomplished.',
        child: Container(
          width: 128,
          height: 25,
          margin: const EdgeInsets.all(5),
          child: const Center(
            child: Text(
              'Completed',
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

}