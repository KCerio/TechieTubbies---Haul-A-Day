import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/controllers/menuController.dart';
import 'package:haul_a_day_web/newUI/components/allOrdersWidget.dart';
import 'package:haul_a_day_web/newUI/components/assignedWidget.dart';
import 'package:haul_a_day_web/newUI/components/navigationBar.dart';
import 'package:haul_a_day_web/newUI/components/orderCount.dart';
import 'package:haul_a_day_web/newUI/components/sidepanel.dart';
import 'package:provider/provider.dart';

class OrderDashboard extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;
  final bool fetchOrderDetails;
  OrderDashboard({super.key, required this.orderDetails, required this.fetchOrderDetails});

  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> {

  List<Map<String, dynamic>> _filteredOrderDetails = [];

  @override
  void initState() {
    super.initState();
    Provider.of<SideMenuSelection>(context, listen: false)
                    .setPreviousTab(TabSelection.Order);
    _filteredOrderDetails = widget.orderDetails;
  }

  void _filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOrderDetails = widget.orderDetails;
      } else {
        _filteredOrderDetails = widget.orderDetails
            .where((order) =>
                order['orderID'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(_filteredOrderDetails);
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical:10),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    
                    child: const Text(
                      'Order Dashboard',
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
                    padding: const EdgeInsets.fromLTRB(100, 0, 100, 10),
                     child: Column(
                       children: [
                         // Order Count
                         orderCounter(orderDetails: widget.orderDetails,),
                            
                         // For Bar Graph
                            
                         // For Assigned Widget
                         
                         Padding(
                           padding: const EdgeInsets.only(bottom: 24),
                           child: Column(
                             children: [
                               Container(
                                padding: const EdgeInsets.only(bottom: 10, top:10),
                                 alignment: Alignment.centerLeft,
                                 child: const Text(
                                   'To be Assigned',
                                   style: TextStyle(
                                     fontFamily: 'Inter',
                                     fontSize: 26,
                                     fontWeight: FontWeight.bold
                                   ),
                                 ),
                               ),
                               
                               const Divider(color: Colors.blue,),
                               const SizedBox(height: 10),

                               Container(
                                 padding: const EdgeInsets.all(16),
                                 height: 250, // Set a fixed height for the container
                                 width: double.infinity, // Make the container expand horizontally
                                 decoration: const BoxDecoration(color: Color.fromARGB(109, 223, 222, 222)),
                                 child: AssignedWidget(orderDetails: widget.orderDetails,)
                               ),
                             ],
                           ),
                         ),
                         
                            
                          //For All Orders Widget
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
                                         'All Orders',
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
                                            _filterOrders(value);
                                          },
                                          decoration: const InputDecoration(
                                            fillColor: Color.fromARGB(109, 223, 222, 222),
                                            filled: true,
                                            hintText: "Search Order",
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
                                 child:  AllOrders(orderDetails: widget.orderDetails)
                               )
                             ],
                           ),
                         ),
                              
                       ],
                     ),
                   );
                 }
               ),
             )
            
          ],
        ),
      ),
    );
  }

}

class HoverContainer extends StatefulWidget {
  final Widget child;
  final Color hoverColor;
  final Color defaultColor;
  final String hoverText;

  const HoverContainer({
    Key? key,
    required this.child,
    required this.hoverColor,
    required this.defaultColor,
    required this.hoverText,
  }) : super(key: key);

  @override
  _HoverContainerState createState() => _HoverContainerState();
}

class _HoverContainerState extends State<HoverContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: _isHovered ? widget.hoverColor : widget.defaultColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
        if (_isHovered)
          Container(
            alignment: Alignment.center,
              width: 120,
              height: 130,
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Text(
                  widget.hoverText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      ],
    );
  }
}

Widget labelButtons() {
  return Row(
    children: [
      HoverContainer(
        hoverColor: const Color.fromRGBO(35, 99, 237, 1),
        defaultColor: const Color.fromRGBO(35, 99, 237, 0.67),
        hoverText: 'Not yet confirmed and assigned',
        child: Container(
          width: 128,
          height: 25,
          margin: const EdgeInsets.all(5),
          child: const Center(
            child: Text(
              'New',
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
        hoverText: 'Confirmed but not assigned',
        child: Container(
          width: 128,
          height: 25,
          margin: const EdgeInsets.all(5),
          child: const Center(
            child: Text(
              'Confirmed',
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
        hoverText: 'Already confirmed and assigned',
        child: Container(
          width: 128,
          height: 25,
          margin: const EdgeInsets.all(5),
          child: const Center(
            child: Text(
              'Assigned',
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