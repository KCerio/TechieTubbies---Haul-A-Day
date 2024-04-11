import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/page/delivery.dart';
import 'package:haul_a_day_web/page/order.dart';
import 'package:haul_a_day_web/page/payroll.dart';
import 'package:haul_a_day_web/page/staffList.dart';
import 'package:haul_a_day_web/page/truck_list.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedItem = 'Home'; // Tracks the selected menu item
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
    
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    // Get the current date
    DateTime now = DateTime.now();

    // Get the current month
    String month = getMonth(now.month);

    // Get the current date
    String currentDate = '${now.day} $month, ${now.year}';

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
                                        Expanded(
                                          child: SingleChildScrollView(
                                    child: Container(
                                      width: 150,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.fromLTRB(
                                                      90, 0, 10, 0),
                                              child: Text(
                                                'Hello, John Doe!',
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
                                            const SizedBox(height: 50),
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
                                              width: 700,
                                              margin: const EdgeInsets.fromLTRB(
                                                  100, 0, 100, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.orangeAccent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  // Icon and Text "Customer X" and "16 December 2023" in a Column
                                                  const Row(
                                                    children: [
                                                      Icon(Icons.content_paste,
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
                                                            'Customer X',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white, // White text color for better visibility
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            '16 December 2023',
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
                                                        'Order',
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
                                                            Navigator.push( 
                                                              context, 
                                                              MaterialPageRoute( 
                                                                  builder: (context) => 
                                                                      const Orderpage())); // Assuming the order tab index is 3
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
                                            const SizedBox(height: 3),
                                            //Team A
                                            Container(
                                              width: 700,
                                              margin: const EdgeInsets.fromLTRB(
                                                  100, 0, 100, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
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
                                            const SizedBox(height: 3),

                                            //Team B
                                            Container(
                                              width: 700,
                                              margin: const EdgeInsets.fromLTRB(
                                                  100, 0, 100, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
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
                                                              .white), // Icon before "Team B"
                                                      SizedBox(
                                                          width:
                                                              5), // Spacer between icon and text
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Team B',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white, // White text color for better visibility
                                                              fontSize: 25,
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
                                            const SizedBox(height: 3),
                                            //Customer Y
                                            Container(
                                              width: 700,
                                              margin: const EdgeInsets.fromLTRB(
                                                  100, 0, 100, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  // Icon and Text "Customer X" and "16 December 2023" in a Column
                                                  const Row(
                                                    children: [
                                                      Icon(Icons.content_paste,
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
                                                            'Customer Y',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white, // White text color for better visibility
                                                              fontSize: 25,
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
                                                        'Order',
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
                                                            Navigator.push( 
                                                              context, 
                                                              MaterialPageRoute( 
                                                                  builder: (context) => 
                                                                      const Orderpage())); // Assuming the order tab index is 3
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
                                            const SizedBox(height: 3),

                                            //Customer Z
                                            Container(
                                              width: 700,
                                              margin: const EdgeInsets.fromLTRB(
                                                  100, 0, 100, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  // Icon and Text "Customer X" and "16 December 2023" in a Column
                                                  const Row(
                                                    children: [
                                                      Icon(Icons.content_paste,
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
                                                            'Customer Z',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white, // White text color for better visibility
                                                              fontSize: 25,
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
                                                        'Order',
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
                                                            Navigator.push( 
                                                            context, 
                                                            MaterialPageRoute( 
                                                                builder: (context) => 
                                                                    const Orderpage())); // Assuming the order tab index is 3
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
                                              ]),
                                            )
                                          )
                                        ),
                                        // Right panel for Home
                                        Expanded(
                                          child: Container(
                                              padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                                              color: Colors.blue[50],
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'TOP TEAM per week',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.symmetric(vertical: 3.0),
                                                      height: 1.0,
                                                      color: Colors.green,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                              AssetImage('images/truck.png'),
                                                        ),
                                                        const SizedBox(width: 8.0),
                                                        const Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Text('Team A',
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                        FontWeight.bold,
                                                                    color: Colors.black)),
                                                            Text('20 Deliveries',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                        FontWeight.normal,
                                                                    color: Colors.black)),
                                                          ],
                                                        ),
                                                        Expanded(child: Container()),
                                                        const Text(
                                                          '>',
                                                          style: TextStyle(
                                                              fontSize: 50,
                                                              color: Colors.green),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 3.0),
                                                      height: 1.0,
                                                      color: Colors.green,
                                                    ),

                                                    Row(
                                                      children: [
                                                        const CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                              AssetImage('images/truck.png'),
                                                        ),
                                                        const SizedBox(width: 8.0),
                                                        const Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Text('Team B',
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                        FontWeight.bold,
                                                                    color: Colors.black)),
                                                            Text('18 Deliveries',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                        FontWeight.normal,
                                                                    color: Colors.black)),
                                                          ],
                                                        ),
                                                        Expanded(child: Container()),
                                                        const Text(
                                                          '>',
                                                          style: TextStyle(
                                                              fontSize: 50,
                                                              color: Colors.green),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 3.0),
                                                      height: 1.0,
                                                      color: Colors.green,
                                                    ),

                                                    Row(
                                                      children: [
                                                        const CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                              AssetImage('images/truck.png'),
                                                        ),
                                                        const SizedBox(width: 8.0),
                                                        const Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Text('Team C',
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                        FontWeight.bold,
                                                                    color: Colors.black)),
                                                            Text('18 Deliveries',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                        FontWeight.normal,
                                                                    color: Colors.black)),
                                                          ],
                                                        ),
                                                        Expanded(child: Container()),
                                                        const Text(
                                                          '>',
                                                          style: TextStyle(
                                                              fontSize: 50,
                                                              color: Colors.green),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 3.0),
                                                      height: 1.0,
                                                      color: Colors.green,
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
                                                          Container(
                                                            margin: const EdgeInsets.symmetric(
                                                                vertical: 8.0),
                                                            height: 1.0,
                                                            color: Colors.orange,
                                                          ), // orange line

                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: [
                                                                    const Text('Delivery',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold)),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                              vertical: 8.0),
                                                                      height: 1.0,
                                                                      color: Colors.orange,
                                                                    ),
                                                                    const Text('2023054'),
                                                                    const Text('2023053'),
                                                                    const Text('2023052'),
                                                                    const Text('2023051'),
                                                                    const Text('2023050'),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text('Truck Team',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold)),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                              vertical: 8.0),
                                                                      height: 1.0,
                                                                      color: Colors.orange,
                                                                    ),
                                                                    const Text('GDC523'),
                                                                    const Text('GDL897'),
                                                                    const Text('GDC523'),
                                                                    const Text('GDL897'),
                                                                    const Text('GDC523'),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.end,
                                                                  children: [
                                                                    const Text('Date',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold)),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                              vertical: 8.0),
                                                                      height: 1.0,
                                                                      color: Colors.orange,
                                                                    ),
                                                                    const Text('12-16-2023'),
                                                                    const Text('12-16-2023'),
                                                                    const Text('12-15-2023'),
                                                                    const Text('12-15-2023'),
                                                                    const Text('12-15-2023'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ])),
                                        ),
                                      ],
                                    );
                                  }
                                )
                          ),
                        ),
                      ),

                      // Right Content (Tab Bar View)
                      
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
}

//the search scrollable list for the user to choose from
//the transparent image
//the search bar sized box
//