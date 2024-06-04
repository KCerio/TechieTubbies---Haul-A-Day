import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/web_Pages/deliveryDashboard/reassignDialog.dart';
import 'package:haul_a_day_web/web_Pages/deliveryDashboard/reschedWidget.dart';
import 'package:haul_a_day_web/web_Pages/orderDashboard/orderdashboard.dart';
import 'package:haul_a_day_web/web_Pages/otherComponents/sidepanel.dart';
import 'package:provider/provider.dart';

class DeliveryDashboard extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;
  final bool fetchOrderDetails;
  DeliveryDashboard({super.key, required this.orderDetails, required this.fetchOrderDetails});

  @override
  State<DeliveryDashboard> createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {
  
  List<Map<String, dynamic>> _filteredOrderDetails = [];
  TextEditingController _searchcontroller = TextEditingController();
  bool notExist = false;

  List<Map<String, dynamic>> _deliverySchedules =[];
  DatabaseService databaseService = DatabaseService();

  List<Map<String, dynamic>> _haltedDeliveries = [];
  bool isfetching = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<SideMenuSelection>(context, listen: false)
    //   .setPreviousTab(TabSelection.Delivery);
    fetchHalted();
    _waitForFetchOrderDetails();
    for(Map<String, dynamic> order in widget.orderDetails){
      if(order['assignedStatus'] == 'true' && order['confirmed_status'] == true){
        _deliverySchedules.add(order);
      }
    }
    print(_deliverySchedules.length);
    
  }

  void fetchHalted() async{
    List<Map<String, dynamic>> halted = await databaseService.fetchHaltedDeliveries();
    print(halted);
    setState(() {
      _haltedDeliveries = halted;
      isfetching = false;
    });
    
  }

  void _waitForFetchOrderDetails() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (widget.fetchOrderDetails == true) {
        setState(() {
          _filteredOrderDetails = _deliverySchedules;
          //print('${widget.fetchOrderDetails}, $_filteredOrderDetails');
        });
      } else {
        _waitForFetchOrderDetails(); // Call the function again if fetchOrderDetails is not true
      }
    });
  }

  void searchOrder(List<Map<String, dynamic>> originalList, String searchQuery) {
    List<Map<String, dynamic>> filteredList = _deliverySchedules;
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
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
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
                       return SingleChildScrollView(
                        child: Column(
                          children: [

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                    padding: const EdgeInsets.only(bottom: 10, top:10),
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Halted Deliveries',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,

                                      ),
                                      child: Text(
                                        _haltedDeliveries.length.toString(),
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                
                                const Divider(color: Colors.blue,),
                                const SizedBox(height: 10),

                                _haltedDeliveries.isEmpty && isfetching == true
                                ? Container(
                                    height: 200,
                                    child: Center(child: CircularProgressIndicator()),
                                  )
                                : Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    height: 250, // Set a fixed height for the container
                                    width: double.infinity, // Make the container expand horizontally
                                    decoration: const BoxDecoration(color: Color.fromARGB(109, 223, 222, 222)),
                                    child: _haltedDeliveries.isEmpty && isfetching == false
                                    ? Container(
                                      height: 300,
                                      child: const Center(
                                        child: Text(
                                          'No deliveries need to be reassigned',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                            ),  
                                          )
                                        ),
                                      )          
                                    : assignCarousel()
                                  )
                                ),
                              ],
                            ),                            
        
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
                                                      _filteredOrderDetails = _deliverySchedules;
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
                                         ),
                                       ),
                                   
                                       
                                       const Divider(color: Colors.blue,),
                                    
                                       Container(
                                         width: double.infinity,
                                         height: 500,
                                         child: _deliverySchedules.isEmpty ? const Center(child: CircularProgressIndicator(),)
                                        : _deliverySchedules.isNotEmpty && notExist == true 
                                        ? Container(
                                            alignment: Alignment.topCenter,
                                            padding: EdgeInsets.only(top: 50),
                                            width: width,
                                            child: Text('Delivery does not exist.',
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
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: _filteredOrderDetails.length,
                                                      itemBuilder: (context, index) {
                                                        return FutureBuilder<Widget>(
                                                          future: deliveryContainer(_filteredOrderDetails[index]),
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
                  )
                )
        
              ],
            ),
          ),
        ),
      ],
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

  Widget assignCarousel(){
    return CarouselSlider.builder(
      itemCount: _haltedDeliveries.length,
      options: CarouselOptions(
        scrollDirection: Axis.horizontal,
        enableInfiniteScroll: false, // Set this to false
        //height: 230,
        //aspectRatio: 16/9,
        viewportFraction: 0.3 ,// Adjust this value to change the number of items seen in every page
        initialPage: 0,
        reverse: false,
        autoPlay: false,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          // Your callback
        },
        scrollPhysics: BouncingScrollPhysics(),
       // itemMargin: 10.0, // Adjust this value to change the distance between widgets
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return haltContainer(_haltedDeliveries[index]);
      },
    );
  }

  Widget haltContainer(Map<String, dynamic> delivery){
   
    return InkWell(
      onTap: () async {
        bool? resolved = await showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            return UpdateSchedule(delivery: delivery, resolved: (value){
              Navigator.of(context).pop(value);
            },);
          },
        );
        
        print(resolved);

        if(resolved!=null && resolved == true){
          setState(() {
            _haltedDeliveries.remove(delivery);
          });
        }

      },
      child: Container(
        padding: EdgeInsets.all(12),
        width: 200,
        height: 220,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 87, 189, 90),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
        ),
        child: Column(
          children: [
            // Text(
            //   delivery['id'],
            //   style: TextStyle(
            //     fontFamily: 'Inter',
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold
            //   ),
            // ),
            Container(
              width:200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white, 
                border: Border(
                  top: BorderSide(color: Colors.black, width: 1.0,),
                  bottom: BorderSide(color: Colors.black, width: 1.0,),
                ),
              ),
              child: Image.asset('images/cargoTruckIcon.png',fit: BoxFit.scaleDown,)
            ),
            const SizedBox(height: 10),
            Text(
              '${delivery['id']} - ${delivery['route']}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Text(
            //   registeredDate,
            //   style: TextStyle(
            //     fontFamily: 'Inter',
            //     fontSize: 14,
                
            //   ),
            // ),
          ],
        )
      ),
    );
  }
}