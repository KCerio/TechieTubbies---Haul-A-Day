import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/trialpage/delivery.dart';
import 'package:haul_a_day_web/trialpage/order.dart';
import 'package:haul_a_day_web/trialpage/menupage2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haul_a_day_web/trialpage/payroll.dart';
import 'package:haul_a_day_web/trialpage/staffList.dart';
import 'package:haul_a_day_web/service/database.dart';

class TruckList extends StatefulWidget {
  const TruckList({super.key});

  @override
  State<TruckList> createState() => _TruckListState();
}

class _TruckListState extends State<TruckList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedItem = 'Truck'; // Tracks the selected menu item
  bool isMouseOverHome = false;
  String greetingText = ''; // Local variable for greeting text
  TextEditingController searchController = TextEditingController(); // Search feature that displays a list of words when clicked
  List<String> searchItems = [
    'Delivery View',
    'View Order',
    'Profile',
    'Trucks',
    'View Payroll',
    'Staff List',
    'Add Staff'
  ];
  bool showSearchResults = false; // Added a boolean showSearchResults to control the visibility of the search results.
  bool isSidePanelExpanded = false;

  bool showTruckInfo = false;
  bool showRemoveTruck = true;
  bool showAddTruck = true;
  bool showFirstContainer = true;
  bool popOverlay = true;
  bool selectTruckColorChanged = true;
  bool _isColorChanged = true;
  bool showListView = true;
  bool hideSidePanel = true;
  bool click = false;

  bool selectaTruck = false;
  Map<String, dynamic> selectedTruck = {};
  List<Map<String, dynamic>> _trucks = [];

  Color _containerColor = Colors.transparent;
  //container backgroun color(truck list)
  void _toggleColor() {
    setState(() {
      _isColorChanged = !_isColorChanged;
      _containerColor = _isColorChanged
          ? Colors.transparent
          : Colors.amberAccent.shade700; // Change
    });
  }

  void _showListView() {
    setState(() {
      showListView = !showListView;
    });
  }

  OverlayEntry? overlayEntry;
  void _handleOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void _hideSidePanel() {
    setState(() {
      hideSidePanel = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabSelection);

    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          showSearchResults = false;
        });
      }
    });
    _initializeTruckData();
    
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeTruckData() async {
    try {
      DatabaseService databaseService = DatabaseService();
      List<Map<String, dynamic>> trucks = await databaseService.fetchAllTruckList();
      setState(() {
        _trucks = trucks;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void selectTruck(Map<String, dynamic> truckSelect){
    truckPanel(truckSelect);
  }

  void _handleTabSelection() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          selectedItem = 'Home';
          break;
        case 1:
          selectedItem = 'Staff';
          break;
        case 2:
          selectedItem = 'Truck';
          break;
        case 3:
          selectedItem = 'Order';
          break;
        case 4:
          selectedItem = 'Delivery';
          break;
        case 5:
          selectedItem = 'Payroll';
          break;
      }
      greetingText = 'Selected: $selectedItem';
    });
  }

  void _handleItemSelection(String selectedItem) {
    setState(() {
      switch (selectedItem) {
        case 'Delivery View':
          _tabController.animateTo(4);
          break;
        case 'View Order':
          _tabController.animateTo(3);
          break;
        case 'Profile':
          _tabController.animateTo(0);
          break;
        case 'Trucks':
          _tabController.animateTo(2);
          break;
        case 'View Payroll':
          _tabController.animateTo(5);
          break;
        case 'Staff List':
          _tabController.animateTo(1);
          break;
        case 'Add Staff':
          _tabController.animateTo(1);
          break;
        case 'Settings':
          // Handle Settings
          break;
      }
      showSearchResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          // Left Side Panel (Side Menu Buttons)
          Container(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              width: isSidePanelExpanded ? 190 : 90,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              color: Colors.blue[100],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 16.0, 8.0, 8.0),
                    child: Image.asset(
                      'images/logo2_trans.png', // Change this to your image path
                      height: 100,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the 'Home' tab
                      // You can replace YourTabScreen with the actual screen you want to navigate to
                    },
                    child: sideMenuButton(
                      'Home',
                      selectedItem == 'Home'
                          ? Colors.white
                          : Colors.transparent,
                      Icons.home_rounded,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap for 'Staff'
                    },
                    child: sideMenuButton(
                      'Staff',
                      selectedItem == 'Staff'
                          ? Colors.white
                          : Colors.transparent,
                      Icons.groups_rounded,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap for 'Truck'
                    },
                    child: sideMenuButton(
                      'Truck',
                      selectedItem == 'Truck'
                          ? Colors.white
                          : Colors.transparent,
                      Icons.local_shipping,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap for 'Order'
                    },
                    child: sideMenuButton(
                      'Order',
                      selectedItem == 'Order'
                          ? Colors.white
                          : Colors.transparent,
                      Icons.fact_check,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap for 'Delivery'
                    },
                    child: sideMenuButton(
                      'Delivery',
                      selectedItem == 'Delivery'
                          ? Colors.white
                          : Colors.transparent,
                      Icons.assignment_add,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap for 'Payroll'
                    },
                    child: sideMenuButton(
                      'Payroll',
                      selectedItem == 'Payroll'
                          ? Colors.white
                          : Colors.transparent,
                      Icons.payment,
                    ),
                  ),
                  // Add more menu items as needed
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the 'Settings' tab
                    },
                    child: sideMenuButton(
                      'Settings',
                      selectedItem == 'Settings'
                          ? Colors.white
                          : Colors.transparent,
                      Icons.settings,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Perform logout action here
                    },
                    child: sideMenuButton(
                      'Log Out',
                      selectedItem == 'Log Out'
                          ? Colors.white
                          : Colors.transparent,
                      Icons.exit_to_app,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rest of the layout (Top Section, Middle Section, Right Section)
          Expanded(
            child: Column(
              children: [
                // Top Section with Search Bar
                Container(
                  height: 70,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Row(
                    children: [
                      const SizedBox(width: 10), // Add some space



                      // Middle Section (Search bar)
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 232, 232),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 30), //icon inside the search  bar
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  //maxLength: 27, // Limiting to 27 characters
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Search order, deliveries and more',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (value) {
                                    // Perform search or filtering based on the input
                                    setState(() {
                                      showSearchResults = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      

                      //sepration
                      Expanded(child: Container()),

                      // Right Section (Notification bell, Menu icon, Profile picture)
                      Row(
                        children: [
                          // Notification bell
                          menuIcon(Icons.notifications, Colors.white),
                          const SizedBox(width: 10),
                          // Menu icon
                          menuIcon(Icons.menu, Colors.white),
                          const SizedBox(width: 10),
                          // Profile picture
                          menuIcon(Icons.account_circle, Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 5, color: Color.fromARGB(255, 235, 173, 4)),

                // Main Content
                Expanded(
                  child: Row(
                    children: [
                      // Middle Content (Placeholder)

                      // Middle Content (Placeholder)
                      Expanded(
                        flex: 4,
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: showSearchResults
                                ? ListView.builder(
                                    itemCount: searchItems.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(searchItems[index]),
                                        onTap: () {
                                          _handleItemSelection(
                                              searchItems[index]);
                                        },
                                      );
                                    },
                                  )
                                : LayoutBuilder(
                                  builder: (context, constraints){
                                    return Row(
                                      children: [
                                        // Left side
                                        Container(
                                          width: size.width * 0.5,        
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                IconButton(
                                                    icon: const Icon(Icons.arrow_back,
                                                        size: 35,
                                                        color: Colors.black),
                                                    onPressed: () {
                                                      // Handle back button press
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    const Homepage(),
                                                          ));
                                                    }),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Text(
                                                    'Truck List',
                                                    style: TextStyle(
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                // Search Truck
                                                const SizedBox(width: 40),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 2, 0, 0),
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      // Your search functionality here
                                                    },
                                                    icon: const Icon(Icons.search,
                                                        color: Colors.black,
                                                        size: 30),
                                                    label: const Text(
                                                      'Search Truck',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.grey),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .horizontal(
                                                          left: Radius.circular(
                                                              5),
                                                          right:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                      backgroundColor: Colors
                                                              .grey[
                                                          300], // Background color of the button
                                                      elevation: 0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            // Add Truck
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        25, 2, 0, 0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // Add truck functionality here
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                        left:
                                                            Radius.circular(2),
                                                        right:
                                                            Radius.circular(2),
                                                      ),
                                                    ),
                                                    backgroundColor: Colors
                                                            .grey[
                                                        300], // Background color of the button
                                                    elevation: 0,
                                                  ),
                                                  child: const Text(
                                                    'Add Truck',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            
                                              const SizedBox(height: 20),
                                              Expanded(
                                                child: _trucks.isEmpty ?  Container(height: size.height*0.8,alignment: Alignment.center,child: CircularProgressIndicator()) 
                                                    : SingleChildScrollView(
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [

                                                        //thy list creates the containers for all the trucks
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                                          itemCount: _trucks.length,
                                                          itemBuilder: (context, index) {
                                                            return buildTruckContainer(_trucks[index]);
                                                          },
                                                        ),
                                                      ],
                                                    )

                                                )
                                            ),
                                              const SizedBox(height: 20),
                                            ]
                                          )
                                        ),
                                        // Right panel for Truck
                                        Expanded(
                                          child: selectaTruck == true 
                                          ? truckPanel(selectedTruck)
                                          :unselectedRightPanel()
                                        ),
                                      ],
                                    );
                                  }
                                )
                          )
                        )
                )
              ]
            )
            )
          ]
      ),
    )
      ])
    );
                      
  }
  

  // Method to create side menu buttons
  //when mouse is not  hovered over them, they will be grey and inactive
  Widget sideMenuButton(String text, Color color, IconData iconData) {
  List<String> menuItems = [
    'Home',
    'Staff',
    'Truck',
    'Order',
    'Delivery',
    'Payroll',
    'Settings',
    'Log Out'
  ];

  return InkWell(
    onTap: () {
      setState(() {
        selectedItem = text;
        switch (text) {
          case 'Home':
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (context) => 
                      const Homepage()));
            break;
          case 'Staff':
            _tabController.animateTo(1);
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (context) => 
                      const StaffList()));
            break;
          case 'Truck':
            _tabController.animateTo(2);
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (context) => 
                      const TruckList()));
            break;
          case 'Order':
            _tabController.animateTo(3);
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (context) => 
                      const Orderpage()));
            break;
          case 'Delivery':
            _tabController.animateTo(4);
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (context) => 
                      const DeliveryPage()));
            break;
          case 'Payroll':
            _tabController.animateTo(5);
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (context) => 
                      const PayrollPage()));
            break;
          case 'Settings':
            // Handle Settings
            break;
          case 'Log Out':
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (context) => 
                      const login_screen()));
            break;
        }
      });
    },
    onHover: (value) {
      setState(() {
        isSidePanelExpanded = value || _tabController.index == menuItems.indexOf(text);
      });
    },
    child: Container(
      height: isSidePanelExpanded ? 50 : 50,
      width: isSidePanelExpanded ? double.infinity : 100,
      color: selectedItem == text ? Colors.white : color,
      padding: EdgeInsets.symmetric(horizontal: isSidePanelExpanded ? 20 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            iconData,
            color: Colors.green,
            size: 30,
          ),
          if (isSidePanelExpanded)
            const SizedBox(width: 10), // Spacing between the icon and title
          if (isSidePanelExpanded)
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}


  // Method to create menu icons
  Widget menuIcon(IconData icon, Color color) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.blue,
      ),
    );
  }

  Widget unselectedRightPanel(){
    return Container(
      height: 450,
      margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
      color: Colors.yellow[100],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping,
              size: 50, color: Colors.black),
          SizedBox(height: 10),
          Text(
            'Select a Truck',
            style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

//for the list
  Widget buildTruckContainer(Map<String, dynamic> aTruck){
    return Container(
      width: 500,
      margin: const EdgeInsets.fromLTRB(
          40, 10, 40, 0),
      padding: const EdgeInsets.fromLTRB(
          10, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.black),
      ),
      child: Row(
        children: [
          //truckPicture
          const CircleAvatar(
            radius: 40,
            backgroundColor:
            Colors.white,
            backgroundImage: AssetImage('images/truck.png'),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                aTruck['id'],
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    Colors.black),
              ),
              Text(
                'Cargo Type: ${aTruck['cargoType']}',
                style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    color:
                    Colors.black),
              ),
              Text(
                'Truck Type: ${aTruck['truckType']}',
                style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    color:
                    Colors.black),
              ),
              Text(
                'Max Capacity: ${aTruck['maxCapacity']} kgs',
                style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    color:
                    Colors.black),
              ),
            ],
          ),
          const Spacer(),
          Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Text(
                  aTruck['truckStatus'],
                  style: const TextStyle(
                      fontWeight:
                      FontWeight
                          .normal,
                      color:
                      Colors.green),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(selectaTruck == false){
                        selectedTruck = aTruck;
                        selectaTruck = true;
                      }
                      else if(selectaTruck == true){
                        selectedTruck = {};
                        selectaTruck = false;
                      }
                    });
                  },
                  style: ElevatedButton
                      .styleFrom(
                    shape:
                    const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .horizontal(
                          left: Radius
                              .circular(
                              5),
                          right: Radius
                              .circular(
                              5),
                        )),
                    backgroundColor: Colors.blue,
                    // click
                    //                         ? Colors
                    //                         .blue
                    //                         : Colors
                    //                         .blue
                    //                         .shade200,
                    foregroundColor:Colors.white,
                    //click
                    //                         ? Colors
                    //                         .white
                    //                         : Colors
                    //                         .black),
                  ),

                  child: const Text('Select'),

                ),
                const SizedBox(height: 10),
                const Icon(Icons.delete),
              ]),
          const SizedBox(width: 5),
        ],
      ),
    );
  }


  //truckPanel Side
Widget truckPanel(Map<String, dynamic> aTruck){
  Size size = MediaQuery.of(context).size;
  return Expanded(
    child: SingleChildScrollView(
      child: Container(
        width: size.width * 0.5,
        color: Colors.green.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              size: 35, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              if(selectaTruck == false){
                                selectedTruck = aTruck;
                                selectaTruck = true;
                              }
                              else if(selectaTruck == true){
                                selectedTruck = {};
                                selectaTruck = false;
                              }
                            });
                          },
                        ),
                        // Add other widgets to the app bar as needed
                      ],
                    ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100, 50, 100, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset('images/truck.png',
                            width: 150.0,
                            height: 150.0,
                            fit: BoxFit.cover, // Adjust the fit as needed
                          ),
                        ),
                      ),
                       Text(
                          aTruck['id'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                      const Text(
                        'Edit Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red,
                            fontSize: 20),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        height: 2,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Container(
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Staff History',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: const BorderRadius.horizontal(),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                              AssetImage('images/user_pic.png',),
                              radius: 30.0,
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Employee Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const Text(
                                  'Staff ID',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const Text(
                                  'Position',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Container(
                                  margin:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  height: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: const BorderRadius.horizontal(),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                              AssetImage('images/user_pic.png',),
                              radius: 30.0,
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Employee Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const Text(
                                  'Staff ID',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const Text(
                                  'Position',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Container(
                                  margin:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  height: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                
            // Add the Delivery History text here
            const Text(
              'Delivery History',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                ),
                const Text(
                  'Filter By:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 25,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.grey, // Set the background color here
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(3),
                        right: Radius.circular(
                            3)), // Optional: Add border radius
                  ),
                  child: DropdownButton<String>(
                    value: 'Delivery Id',
                    onChanged: (String? newValue) {
                      // Handle dropdown value change
                    },
                    items: <String>['Delivery Id']
                        .map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                color: Colors.black), // Set text color
                          ),
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              // height:110,
              // width:320,
              color: Colors.lightGreen.shade400,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Delivery',
                                style:
                                TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              height: 1.0,
                              color: Colors.orange,
                            ),
                            const Text('2023054'),
                            const Text('2023053'),
                            const Text('2023052'),
                            const Text('2023051'),
                            const Text('2023050'),
                          ])),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Customer',
                                style:
                                TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              height: 1.0,
                              color: Colors.orange,
                            ),
                            const Text('GDC523'),
                            const Text('GDL897'),
                            const Text('GDC523'),
                            const Text('GDL897'),
                            const Text('GDC523'),
                          ])),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Date',
                                style:
                                TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              height: 1.0,
                              color: Colors.orange,
                            ),
                            const Text('12-16-2023'),
                            const Text('12-16-2023'),
                            const Text('12-15-2023'),
                            const Text('12-15-2023'),
                            const Text('12-15-2023'),
                          ])),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Incident Reports',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                ),
                const Text(
                  'Filter By:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 25,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.grey, // Set the background color here
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(3),
                        right: Radius.circular(
                            3)), // Optional: Add border radius
                  ),
                  child: DropdownButton<String>(
                    value: 'Delivery Id',
                    onChanged: (String? newValue) {
                      // Handle dropdown value change
                    },
                    items: <String>['Delivery Id']
                        .map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                color: Colors.black), // Set text color
                          ),
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.lightGreen.shade400,
              // height:110,
              // width:320,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('DATE ',
                                style:
                                TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              height: 1.0,
                              color: Colors.orange,
                            ),
                            const Text('11-14-2023'),
                            const SizedBox(height: 1),
                            const Text('10-05-2023'),
                            const SizedBox(height: 1),
                            const Text('05-04-2023'),
                            const SizedBox(height: 1),
                            const Text('05-01-2023'),
                            const SizedBox(height: 1),
                            const Text('12-20-2022'),
                            const SizedBox(height: 1),
                          ])),
                  const SizedBox(height: 1),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('DESCRIPTION',
                                style:
                                TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              height: 1.0,
                              color: Colors.orange,
                            ),
                            const Text('Broken Bumper',),
                                //style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 1),
                            const Text('Accident during delivery',),
                                //style: TextStyle(fontSize: 11)),
                            const SizedBox(height: 1),
                            const Text('Flat Tire', ),
                            //style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 1),
                            const Text('Broken Headlights',),
                                //style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 1),
                            const Text('Unstable Breaks',),
                                //style: TextStyle(fontSize: 12)),
                          ])),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('REMARK',
                                style:
                                TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              height: 1.0,
                              color: Colors.orange,
                            ),
                            const Text('On-Repair'),
                            const SizedBox(height: 1),
                            const Text('Unsuccessful'),
                            const SizedBox(height: 1),
                            const Text('Unsuccessful'),
                            const SizedBox(height: 1),
                            const Text('On-Repair'),
                            const SizedBox(height: 1),
                            const Text('On_repair'),
                      ]
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}


}

//the search scrollable list for the user to choose from
//the transparent image
//the search bar sized box
//

