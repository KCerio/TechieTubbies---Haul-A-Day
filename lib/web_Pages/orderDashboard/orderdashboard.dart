import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/web_Pages/orderDashboard/assignedWidget.dart';
import 'package:haul_a_day_web/web_Pages/orderDashboard/orderCount.dart';
import 'package:haul_a_day_web/web_Pages/otherComponents/sidepanel.dart';
import 'package:provider/provider.dart';

class OrderDashboard extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;
  final bool fetchOrderDetails;
  OrderDashboard({super.key, required this.orderDetails, required this.fetchOrderDetails});

  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> {
  DatabaseService databaseService = DatabaseService();
  List<Map<String, dynamic>> _filteredOrderDetails = [];
  TextEditingController _searchcontroller = TextEditingController();
  bool notExist = false;

  @override
  void initState() {
    super.initState();
    Provider.of<SideMenuSelection>(context, listen: false)
        .setPreviousTab(TabSelection.Order);
    //fetchOrder();
    _waitForFetchOrderDetails();
  }

  // void fetchOrder() async{
  //   List<Map<String, dynamic>> orders = await databaseService.fetchAllOrderList();
  //   setState(() {
  //     _filteredOrderDetails = orders;
  //   });
  // }

  void _waitForFetchOrderDetails() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (widget.fetchOrderDetails == true) {
        setState(() {
          _filteredOrderDetails = widget.orderDetails;
          //print('${widget.fetchOrderDetails}, $_filteredOrderDetails');
        });
      } else {
        _waitForFetchOrderDetails(); // Call the function again if fetchOrderDetails is not true
      }
    });
  }

  void searchOrder(List<Map<String, dynamic>> originalList, String searchQuery) {
    List<Map<String, dynamic>> filteredList = widget.orderDetails;
    if(searchQuery != ''){
      // Convert the search query to lowercase for case-insensitive matching
      final query = searchQuery.toLowerCase();

      // Filter the original list based on the search query
      filteredList = originalList.where((map) {
        // Iterate through each key-value pair in the map
        // and check if any value contains the search query
        return map.values.any((value) {
          if (value is String) {
            // If the value is a string, check if it contains the search query
            return value.toLowerCase().contains(query);
          }
          // If the value is not a string, convert it to a string and check if it contains the search query
          return value.toString().toLowerCase().contains(query);
        });
      }).toList();
      print("Searched List: $filteredList");
      
    }

    if(filteredList.isEmpty){
      setState(() {
        notExist = true;
      });
    }
    else{
      setState(() {
        _filteredOrderDetails = filteredList;
      });
    }
    
  }


  @override
  Widget build(BuildContext context) {
    //print(_filteredOrderDetails);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
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
                               child: AssignedWidget(orderDetails: widget.orderDetails,)
                             ),
                             
                                
                              //For All Orders Widget
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: LayoutBuilder(
                                 builder: (context, constraints) {
                                  double width = constraints.maxWidth;
                                  double height = constraints.maxHeight;
                                   return Column(
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
                                              Row(
                                                children: [
                                                  Container(
                                                    width: width*0.25,
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 228, 228, 228), // White background color
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: TextField(
                                                      controller: _searchcontroller,
                                                      onSubmitted: (_){
                                                        searchOrder(_filteredOrderDetails, _searchcontroller.text);
                                                      },
                                                      onChanged: (value){                                            
                                                        setState(() {
                                                          //if(_selectedFilter == ''){_selectedFilter = 'All';}
                                                          // applyFilter(_selectedFilter);
                                                            notExist = false;
                                                          _filteredOrderDetails = widget.orderDetails;
                                                        });
                                                        searchOrder(_filteredOrderDetails, _searchcontroller.text);
                                                      },
                                                      decoration: InputDecoration(
                                                        hintText: 'Search...',
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                          borderSide: BorderSide.none, // Hide border
                                                        ),
                                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(255, 87, 189, 90), // Blue color for the search icon button
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        // Implement search functionality here
                                                        searchOrder(_filteredOrderDetails, _searchcontroller.text);
                                                      },
                                                      icon: Icon(Icons.search),
                                                      color: Colors.white, // White color for the search icon
                                                    ),
                                                  ),
                                                ],
                                              )
                                           ],
                                         ),
                                       ),
                                       
                                       const Divider(color: Colors.blue,),
                                    
                                       Container(
                                         width: double.infinity,
                                         height: 500,
                                         child:  notExist == true 
                                        ? Container(
                                            alignment: Alignment.topCenter,
                                            padding: EdgeInsets.only(top: 50),
                                            width: width,
                                            child: Text('Order does not exist.',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                                ), 
                                              ),
                                          )
                                        : Column(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    //thy list creates the containers for all the trucks
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                                      itemCount: _filteredOrderDetails.length,
                                                      itemBuilder: (context, index) {
                                                        return orderContainer(_filteredOrderDetails[index]);
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ),
                                            ),
                                          ],
                                        )
                                       )
                                     ],
                                   );
                                 }
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
        ),
      ],
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