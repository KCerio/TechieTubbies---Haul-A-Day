import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/controllers/menuController.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/service/payrollService.dart';
import 'package:haul_a_day_web/web_Pages/deliveryDashboard/delivery.dart';
import 'package:haul_a_day_web/web_Pages/orderDashboard/orderdashboard.dart';
import 'package:haul_a_day_web/web_Pages/orderDetails/orderdetails.dart';
import 'package:haul_a_day_web/web_Pages/otherComponents/navigationBar.dart';
import 'package:haul_a_day_web/web_Pages/otherComponents/sidepanel.dart';
import 'package:haul_a_day_web/web_Pages/payrollPage/payroll.dart';
import 'package:haul_a_day_web/web_Pages/profile-settingsPage/profile_settings.dart';
import 'package:haul_a_day_web/web_Pages/staffDirectory/stafflist.dart';
import 'package:haul_a_day_web/web_Pages/truckList/trucklist.dart';
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  Homepage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseService databaseService = DatabaseService();
  PayrollService payrollService = PayrollService();

  List<Map<String, dynamic>> _orderDetails = [];
  bool fetchingStatus = false; // if fecthing data is finished
  Map<int, List<Map<String, dynamic>>> _groupedOrders = {};
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
    List<Map<String, dynamic>> orderDetails = await databaseService.fetchAllOrderList();
    setState(() {
      _orderDetails = orderDetails;
      fetchingStatus = true;
    });
  
    } catch (e){
      print('Failed to fetch order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(userInfo: widget.userInfo),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 236, 234, 234),
                child: NavigationTopBar(userInfo: widget.userInfo),
                height: 100, // Adjust the height as needed
              ),
              Expanded(
                child: Consumer<SideMenuSelection>(
                  builder: (context, sideMenuSelection, _) {
                    TabSelection _tabSelection = sideMenuSelection.selectedTab;
                    Map<String, dynamic> orderSelected = sideMenuSelection.orderSelected;
                    TabSelection _previousTab = sideMenuSelection.previousTab;
                
                    Widget selectedWidget;
                    switch (_tabSelection) {
                      case TabSelection.Home:
                        selectedWidget = Home(userFirstName: widget.userInfo['firstname']);
                        break;
                      case TabSelection.StaffList:
                        selectedWidget = StaffList(
                          userId: widget.userInfo['staffId'],
                          accessKey: widget.userInfo['accessKey'],
                        );
                        break;
                      case TabSelection.TruckList:
                        selectedWidget = TruckList();
                        break;
                      case TabSelection.Order:
                        selectedWidget = OrderDashboard(
                          orderDetails: _orderDetails,
                          fetchOrderDetails: fetchingStatus,
                        );
                        break;
                      case TabSelection.OrderDetails:
                        selectedWidget = OrderDetailsPage(
                          order: orderSelected,
                          previousTab: _previousTab,
                        );
                        break;
                      case TabSelection.Delivery:
                        selectedWidget = DeliveryDashboard(
                          orderDetails: _orderDetails,
                          fetchOrderDetails: fetchingStatus,
                        );
                        break;
                      case TabSelection.Payroll:
                        selectedWidget = Payroll(groupedOrders: _groupedOrders);
                        break;
                      case TabSelection.Profile:
                        selectedWidget = Profile_Settings(profile: true, settings: false, userInfo: widget.userInfo);
                        break;
                      case TabSelection.Settings:
                        selectedWidget = Profile_Settings(profile: false, settings: true, userInfo: widget.userInfo);
                        break;
                      default:
                        selectedWidget = Container();
                        break;
                    }
                    return selectedWidget;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Home extends StatefulWidget {
  final String userFirstName;
  const Home({super.key, required this.userFirstName});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  List<Map<String, dynamic>> _trucks = [];
  List<Map<String, dynamic>> _accomplishedDeliveries = [];

  @override
  void initState() {
    super.initState();
    _initializeTruckData();
  }

  Future<void> _initializeTruckData() async {
    try {
      QuerySnapshot truckSnapshots =
          await FirebaseFirestore.instance.collection('Trucks').get();

      List<Map<String, dynamic>> allTrucks = [];
      for (var truckSnapshot in truckSnapshots.docs) {
        if (truckSnapshot.exists) {
          Map<String, dynamic> data = truckSnapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> truckData = {};
          truckData['id'] = truckSnapshot.id; // Include the document ID
          truckData['truckPic'] = data['truckPic'];
          //check if truck has accomplished deliveries
          QuerySnapshot deliveriesSnapshots =
          await FirebaseFirestore.instance.collection('Trucks').doc(truckData['id']).collection('Accomplished Deliveries').get();
          if(deliveriesSnapshots.docs.isNotEmpty){
            //create string list of document ids in the accomplished deliveries
            List<String> accomplishedDeliveryIds = [];
            for (var deliverySnapshot in deliveriesSnapshots.docs) {
              accomplishedDeliveryIds.add(deliverySnapshot.id);
            }
            truckData['accomplishedDeliveries'] = accomplishedDeliveryIds;
            allTrucks.add(truckData);
          }
        }
      }
      setState(() {
        _trucks = allTrucks;
      });
      sortList(_trucks);
      //print(_trucks);
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void sortList(List<Map<String, dynamic>> list) {
    print('here');
    // Comparator function to compare two maps based on the specified key
    String sortBy = 'accomplishedDeliveries';

    int compare(Map<String, dynamic> a, Map<String, dynamic> b) {
      // Access the values of the specified key from each map
      var aValue = a[sortBy].length;
      var bValue = b[sortBy].length;

      // Compare the values and return the result
      if (aValue is String && bValue is String) {
        // For string comparison
        return bValue.compareTo(aValue); // Reverse comparison for descending order
      } else if (aValue is int && bValue is int) {
        // For integer comparison
        return bValue.compareTo(aValue); // Reverse comparison for descending order
      } else {
        // Handle other types if needed
        return 0;
      }
    }
    
    // Sort the list using the comparator function
    list.sort(compare);
    
    setState(() {
      _trucks = list;
    });
  }


  String getMonth(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
      return 'August';
      case 9:
      return 'September';
      case 10:
      return 'October';
      case 11:
      return 'November';
      case 12:
      return 'December';
      default:
        return '';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Get the current date
    DateTime now = DateTime.now();

    // Get the current month
    String month = getMonth(now.month);

    // Get the current date
    String currentDate = '${now.day} $month, ${now.year}';

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints){
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          return Row(
            children: [
              //Left panel
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: width*0.5,
                  height: height,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(
                                    90, 0, 10, 0),
                            child: Text(
                              'Hello, ${widget.userFirstName}',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                            Padding(
                            padding:
                                const EdgeInsets.fromLTRB(
                                    90, 2, 0, 0),
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                Text(
                                  currentDate,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                                90, 0, 105, 0),
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Divider(
                                        color: Colors.green)),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(
                                          2, 0, 0, 0),
                                  child: Text(
                                    'Notifications',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight
                                            .normal),
                                  ),
                                ),
                                Expanded(
                                    child: Divider(
                                        color: Colors.green)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 410,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                      itemCount: 8,
                                      itemBuilder: (context, index) {
                                        return notifContainer(index);
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),      
                      ]
                    ),
                  ),
                )
              ),
              // Right panel for Home
              Expanded(
                child: Container(
                    width: width*0.5,
                    height: height,
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                    color: Colors.blue[50],
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              width:  width*0.5,
                              decoration: const BoxDecoration(
                                  //color: Color.fromARGB(255, 211, 208, 208), 
                                  border: Border( // Adding a border
                                    bottom: BorderSide(color: Colors.green, // Border color
                                    width: 1.0,),// Border width
                                ),
                              ),
                              child: const Text(
                                'TOP TEAM per week',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            
                            _trucks.isEmpty ? SizedBox(height: 200,) 
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                              itemCount: _trucks.length > 3 ? 3 : _trucks.length,
                              itemBuilder: (context, index) {
                                return topTeam(_trucks[index]);
                              },
                            ),
                                      
                            // Separation
                            // Expanded(child: Container()),
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Accomplished Deliveries',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const SizedBox(height:10),
                                  Container(
                                    width:  width*0.5,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        //color: Color.fromARGB(255, 211, 208, 208), 
                                        border: Border( // Adding a border
                                          bottom: BorderSide(color: Colors.amber, // Border color
                                          width: 1.0,),
                                          top: BorderSide(color: Colors.amber, // Border color
                                          width: 1.0,),// Border width
                                      ),
                                    ),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        double width = constraints.maxWidth;
                                        return Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: width*1/3,
                                              child: const Text('Delivery',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight
                                                            .bold,
                                                    fontSize: 16)),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: width*1/3,
                                              child: const Text('Truck Team',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight
                                                            .bold,
                                                    fontSize: 16)),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: width*1/3,
                                              child: const Text('Date',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight
                                                            .bold,
                                                    fontSize: 16)),
                                            )
                                          ],
                                        );
                                      },
                                    )
                                  ),

                                  Container(
                                    height: 250,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                            itemCount: 14,
                                            itemBuilder: (context, index) {
                                              return accomplishedTable(width, index);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),                                   
                                ],
                              ),
                            ),
                          ]),
                    )),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget notifContainer(int index){
    return Column(
      children: [
        Container(
          width: 700,
          margin: const EdgeInsets.fromLTRB(
              100, 0, 100, 0),
          padding: const EdgeInsets.fromLTRB(
              10, 0, 0, 0),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // Icon and Text "Customer X" and "16 December 2023" in a Column
              const Row(
                children: [
                  Icon(Icons.local_shipping,
                      size: 50,
                      color: Colors
                          .white), // Icon before "Customer X"
                  SizedBox(
                      width:
                          5), // Spacer between icon and text
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'Team A',
                        style: TextStyle(
                          color: Colors
                              .white, // White text color for better visibility
                          fontSize: 35,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      Text(
                        '15 December 2023',
                        style: TextStyle(
                          color: Colors
                              .white, // White text color for better visibility
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        
              // Spacer to push the "Order" text and arrows to the right
              const Spacer(),
        
              //Text Order
              Row(
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight
                                .normal,
                        color:
                            Colors.white),
                  ),
                  GestureDetector(
                      onTap: () {
                        // Assuming the order tab index is 3
                      },
                      child: const Icon(
                        Icons
                            .keyboard_double_arrow_right_outlined,
                        size:
                            50, // Set the size of the icon
                        color: Colors
                            .white, // Set the color of the icon
                      )),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height:5)
      ],
    );
  }
  
  Widget topTeam(Map<String, dynamic> truckteam){
    return InkWell(
      onTap:(){},
      child: Container(
        padding: const EdgeInsets.only(right: 16,left:10),
        decoration: const BoxDecoration(
            //color: Color.fromARGB(255, 211, 208, 208), 
            border: Border( // Adding a border
              bottom: BorderSide(color: Colors.green, // Border color
              width: 1.0,),// Border width
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: truckteam['truckPic'] != null
                  ? Image.network(truckteam['truckPic'],).image
                  : Image.asset('images/truck.png',).image,
            ),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(truckteam['id'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.black)),
                Text('${truckteam['accomplishedDeliveries'].length} Deliveries',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.normal,
                        color: Colors.black)),
              ],
            ),
            const Spacer(),
            const Text(
              '>',
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget accomplishedTable(double width, int index){
    return Container(
      width:  width*0.5,
      height: 35,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          return Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: width*1/3,
                child: const Text('Delivery',
                  style: TextStyle(
                      fontWeight:
                          FontWeight
                              .normal)),
              ),
              Container(
                alignment: Alignment.center,
                width: width*1/3,
                child: const Text('Truck Team',
                  style: TextStyle(
                      fontWeight:
                          FontWeight
                              .normal)),
              ),
              Container(
                alignment: Alignment.center,
                width: width*1/3,
                child: const Text('Date',
                  style: TextStyle(
                      fontWeight:
                          FontWeight
                              .normal)),
              )
            ],
          );
        },
      )
    );
  }
}