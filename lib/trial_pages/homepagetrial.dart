import 'dart:html';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/page/order.dart';
import 'package:haul_a_day_web/page/orderpage.dart';
import 'package:haul_a_day_web/trial_pages/ordercontent.dart';
import 'package:haul_a_day_web/page/orderscreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedItem = 'Home'; // Tracks the selected menu item
  bool isMouseOverHome = false;
  String greetingText = ''; // Local variable for greeting text
  TextEditingController searchController =
      TextEditingController(); // Search feature that displays a list of words when clicked
  List<String> suggestions = [
    'Delivery View',
    'View Order',
    'Profile',
    'Trucks',
    'View Payroll',
    'Staff List',
    'Add Staff'
  ];

  bool searchResults =
      false; // Added a boolean showSearchResults to control the visibility of the search results.
  bool isSidePanelExpanded = false;

  BuildContext get index => index;
  bool overlayVisible = false;
  bool showOverlay = false; // Initially set to true to show the overlay
  bool tileTapped = false; // Flag to track if a ListTile is tapped
  
  bool isHovered = false;
  
  
  
  
  bool showAnimatedPop = true;
  
  bool click = false;
  bool _isColorChanged = true;
  bool showListView = true;
  bool showStaffContainer = true;
  bool hideSidePanel = true;
  late List<Widget> _tabContent;


  bool showTruckInfo = false;
  bool showRemoveTruck = true;
  bool showAddTruck = true;
  bool showFirstContainer = true;
  bool popOverlay = true;
  bool selectTruckColorChanged = true;

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

  void _handleOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void _hideSidePanel() {
    setState(() {
      hideSidePanel = true;
    });
  }

  set isHomeHovered(bool isHomeHovered) {}

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabSelection);

    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          searchResults = false;
        });
      }
    });

    _tabContent = [
      const TabContent(text: 'Tab 1 Content'),
      const TabContent(text: 'Tab 2 Content'),
      const TabContent(text: 'Tab 3 Content'),
      const OrderContent(),
      const TabContent(text: 'Tab 2 Content'),
      const TabContent(text: 'Tab 3 Content'),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  OverlayEntry? overlayEntry;

  void _switchToTab(int index) {
    setState(() {});
    _tabController.animateTo(index); // Switch to the selected tab
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
      searchResults = false;
    });
  }

  void updateTabContent(int index) {
    setState(() {
      // Replace the content of the selected tab with a new widget
      //_tabContent[index] = OrderScreen(orderId: orderId, status: status);
    });
  }


  @override
  Widget build(BuildContext context) {
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

          Expanded(
            child: Column(
              children: [
                // Top Section with Search Bar
                Container(
                  height: 70,
                  color: Colors.white,
                  child: Row(
                    children: [
                      const SizedBox(width: 10), // Add some space

                      // Middle Section (Search bar)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (overlayEntry != null) {
                                      overlayEntry?.remove();
                                      overlayEntry = null;
                                    } else {
                                      overlayEntry = OverlayEntry(
                                        builder: (context) => Positioned(
                                          top: 60.0,
                                          left: 100.0,
                                          right: 800.0,
                                          height: 200.0,
                                          child: Material(
                                            child: Container(
                                              width: 200.0,
                                              height: 200.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Set the border radius
                                              ),
                                              child: Center(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Scrollbar(
                                                        child: ListView(
                                                          shrinkWrap: true,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: ListTile(
                                                                leading: const Icon(Icons
                                                                    .content_paste_search_rounded),
                                                                title: const Text(
                                                                    'Delivery View'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedItem =
                                                                        'Delivery view';
                                                                    _tabController
                                                                        .animateTo(
                                                                            4);
                                                                  });
                                                                  overlayEntry
                                                                      ?.remove();
                                                                  overlayEntry =
                                                                      null;
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            3.0),
                                                                height: 3.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: ListTile(
                                                                leading: const Icon(Icons
                                                                    .content_paste_search_rounded),
                                                                title: const Text(
                                                                    'View Order'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedItem =
                                                                        'View Order';
                                                                    _tabController
                                                                        .animateTo(
                                                                            3);
                                                                  });
                                                                  overlayEntry
                                                                      ?.remove();
                                                                  overlayEntry =
                                                                      null;
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            3.0),
                                                                height: 3.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: ListTile(
                                                                leading: const Icon(
                                                                    Icons
                                                                        .comment),
                                                                title: const Text(
                                                                    'Profile'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedItem =
                                                                        'Profile';
                                                                    _tabController
                                                                        .animateTo(
                                                                            0);
                                                                  });
                                                                  overlayEntry
                                                                      ?.remove();
                                                                  overlayEntry =
                                                                      null;
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        3.0),
                                                                height: 3.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: ListTile(
                                                                leading: const Icon(
                                                                    Icons
                                                                        .comment),
                                                                title: const Text(
                                                                    'Trucks'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedItem =
                                                                        'Trucks';
                                                                    _tabController
                                                                        .animateTo(
                                                                            2);
                                                                  });
                                                                  overlayEntry
                                                                      ?.remove();
                                                                  overlayEntry =
                                                                      null;
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            3.0),
                                                                height: 3.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: ListTile(
                                                                leading: const Icon(Icons
                                                                    .content_paste_search_rounded),
                                                                title: const Text(
                                                                    'View Payroll'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedItem =
                                                                        'View Payroll';
                                                                    _tabController
                                                                        .animateTo(
                                                                            5);
                                                                  });
                                                                  overlayEntry
                                                                      ?.remove();
                                                                  overlayEntry =
                                                                      null;
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            3.0),
                                                                height: 3.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: ListTile(
                                                                leading: const Icon(
                                                                    Icons
                                                                        .comment),
                                                                title: const Text(
                                                                    'Staff List'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedItem =
                                                                        'Staff List';
                                                                    _tabController
                                                                        .animateTo(
                                                                            1);
                                                                  });
                                                                  overlayEntry
                                                                      ?.remove();
                                                                  overlayEntry =
                                                                      null;
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            3.0),
                                                                height: 3.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: ListTile(
                                                                leading: const Icon(Icons
                                                                    .content_paste_search_rounded),
                                                                title: const Text(
                                                                    'Add Staff'),
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedItem =
                                                                        'Add Staff';
                                                                    _tabController
                                                                        .animateTo(
                                                                            1);
                                                                  });
                                                                  overlayEntry
                                                                      ?.remove();
                                                                  overlayEntry =
                                                                      null;
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            3.0),
                                                                height: 3.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      Overlay.of(context)
                                          ?.insert(overlayEntry!);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(5),
                                        right: Radius.circular(5),
                                      ),
                                    ),
                                    backgroundColor: Colors.grey[200],
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.search,
                                          color: Colors.black),
                                      SizedBox(
                                          width:
                                              8), // Add some spacing between icon and text
                                      Text('Search order, deliveries and more',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //separation
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
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 5, color: Color.fromARGB(255, 235, 173, 4)),

                // Expanded Section with TabBarView
                Expanded(
                  flex: 4,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Home Tab Content
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Text(
                                  'Home Content',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
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
                                                AssetImage('images/truck1.png'),
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
                                                AssetImage('images/truck1.png'),
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
                                                AssetImage('images/truck1.png'),
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
                      ),
                      // Staff Tab Content
                      Row(
                        children: [
                          SingleChildScrollView(
                            child: Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                    'Staff List',
                                                    style: TextStyle(
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                // Search Truck
                                                const SizedBox(width: 40),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            // Add Truck

                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          25, 2, 0, 0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      // Remove truck functionality here
                                                    },
                                                    child: const Text(
                                                      'Remove Employee',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .horizontal(
                                                          left: Radius.circular(
                                                              2),
                                                          right:
                                                              Radius.circular(
                                                                  2),
                                                        ),
                                                      ),
                                                      backgroundColor: Colors
                                                              .grey[
                                                          300], // Background color of the button
                                                      elevation: 0,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          25, 2, 0, 0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      // Add truck functionality here
                                                    },
                                                    child: const Text(
                                                      'Add New Employee',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .horizontal(
                                                          left: Radius.circular(
                                                              2),
                                                          right:
                                                              Radius.circular(
                                                                  2),
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
                                            Container(
                                              width: 500,
                                              margin: const EdgeInsets.fromLTRB(
                                                  40, 10, 40, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                color: _containerColor,
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        'images/truck1.png'),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Name',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Staff ID',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Position',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Status',
                                                        style: TextStyle(
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
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(
                                                            () {
                                                              showAddTruck =
                                                                  !showAddTruck;
                                                              showRemoveTruck =
                                                                  !showRemoveTruck;
                                                              showTruckInfo =
                                                                  !showTruckInfo;
                                                              popOverlay =
                                                                  !popOverlay;
                                                              selectTruckColorChanged =
                                                                  !selectTruckColorChanged;
                                                              click = !click;
                                                              showStaffContainer =
                                                                  !showStaffContainer;
                                                              _toggleColor();
                                                            },
                                                          );
                                                        },
                                                        child: const Text('Select'),
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
                                                                backgroundColor:
                                                                    click
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .blue
                                                                            .shade200,
                                                                foregroundColor:
                                                                    click
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              width: 500,
                                              margin: const EdgeInsets.fromLTRB(
                                                  40, 10, 40, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                // color: _containerColor,
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        'images/truck1.png'),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Name',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Staff ID',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Position',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Status',
                                                        style: TextStyle(
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
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        child: const Text('Select'),
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
                                                                backgroundColor:
                                                                    Colors.blue
                                                                        .shade200),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              width: 500,
                                              margin: const EdgeInsets.fromLTRB(
                                                  40, 10, 40, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        'images/truck1.png'),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Name',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Satff ID',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Position',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Status',
                                                        style: TextStyle(
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
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        child: const Text('Select'),
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
                                                                backgroundColor:
                                                                    Colors.blue
                                                                        .shade200),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              width: 500,
                                              margin: const EdgeInsets.fromLTRB(
                                                  40, 10, 40, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        'images/truck1.png'),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Name',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Staff ID',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Position',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Status',
                                                        style: TextStyle(
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
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        child: const Text('Select'),
                                                        style: ElevatedButton.styleFrom(
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.horizontal(
                                                                    left: Radius
                                                                        .circular(
                                                                            5),
                                                                    right: Radius
                                                                        .circular(
                                                                            5))),
                                                            backgroundColor:
                                                                Colors.blue
                                                                    .shade200),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Right panel for Staff
                          Expanded(
                            child: Container(
                              height: 450,
                              margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                              padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                              color: Colors.yellow[100],
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.face_4_rounded,
                                      size: 50, color: Colors.black),
                                  SizedBox(height: 10),
                                  Text(
                                    'Select an Employee',
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Truck Tab Content
                      Row(
                        children: [
                          SingleChildScrollView(
                            child: Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            if (showFirstContainer)
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
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (!showFirstContainer) //switch
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(25, 2, 0, 0),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // Remove truck functionality here
                                                      },
                                                      child: const Text(
                                                        'Remove Truck',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .horizontal(
                                                            left:
                                                                Radius.circular(
                                                                    2),
                                                            right:
                                                                Radius.circular(
                                                                    2),
                                                          ),
                                                        ),
                                                        backgroundColor: Colors
                                                                .grey[
                                                            300], // Background color of the button
                                                        elevation: 0,
                                                      ),
                                                    ),
                                                  ),
                                                const SizedBox(width: 10),
                                                if (!showAddTruck)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(25, 2, 0, 0),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // Add truck functionality here
                                                      },
                                                      child: const Text(
                                                        'Add Truck',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .horizontal(
                                                            left:
                                                                Radius.circular(
                                                                    2),
                                                            right:
                                                                Radius.circular(
                                                                    2),
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
                                            Container(
                                              width: 500,
                                              margin: const EdgeInsets.fromLTRB(
                                                  40, 10, 40, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                color: _containerColor,
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        'images/truck1.png'),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Truck ID',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Cargo Type:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Truck Type:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Max Capacity:',
                                                        style: TextStyle(
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
                                                      const Text(
                                                        'Truck Status',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(
                                                            () {
                                                              showAddTruck =
                                                                  !showAddTruck;
                                                              showRemoveTruck =
                                                                  !showRemoveTruck;
                                                              showTruckInfo =
                                                                  !showTruckInfo;
                                                              showFirstContainer =
                                                                  !showFirstContainer;
                                                              popOverlay =
                                                                  !popOverlay;
                                                              selectTruckColorChanged =
                                                                  !selectTruckColorChanged;
                                                              click = !click;
                                                              _toggleColor();
                                                            },
                                                          );
                                                        },
                                                        child: const Text('Select'),
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
                                                                backgroundColor:
                                                                    click
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .blue
                                                                            .shade200,
                                                                foregroundColor:
                                                                    click
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      const Icon(Icons.delete),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              width: 500,
                                              margin: const EdgeInsets.fromLTRB(
                                                  40, 10, 40, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                // color: _containerColor,
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        'images/truck1.png'),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Truck ID',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Cargo Type:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Truck Type:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Max Capacity:',
                                                        style: TextStyle(
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
                                                      const Text(
                                                        'Truck Status',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        child: const Text('Select'),
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
                                                                backgroundColor:
                                                                    Colors.blue
                                                                        .shade200),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      const Icon(Icons.delete),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              width: 500,
                                              margin: const EdgeInsets.fromLTRB(
                                                  40, 10, 40, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        'images/truck1.png'),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Truck ID',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Cargo Type:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Truck Type:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Max Capacity:',
                                                        style: TextStyle(
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
                                                      const Text(
                                                        'Truck Status',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        child: const Text('Select'),
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
                                                                backgroundColor:
                                                                    Colors.blue
                                                                        .shade200),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      const Icon(Icons.delete),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              width: 500,
                                              margin: const EdgeInsets.fromLTRB(
                                                  40, 10, 40, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        'images/truck1.png'),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Truck ID',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Cargo Type:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Truck Type:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Max Capacity:',
                                                        style: TextStyle(
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
                                                      const Text(
                                                        'Truck Status',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        child: const Text('Select'),
                                                        style: ElevatedButton.styleFrom(
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.horizontal(
                                                                    left: Radius
                                                                        .circular(
                                                                            5),
                                                                    right: Radius
                                                                        .circular(
                                                                            5))),
                                                            backgroundColor:
                                                                Colors.blue
                                                                    .shade200),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      const Icon(Icons.delete),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Right panel for Truck
                          Expanded(
                            child: Container(
                              color: Colors.green[300],
                              child: const Center(
                                child: Text(
                                  'Truck Right Panel',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      
                      // Order Tab Content
                      Container(
                        color: Colors.white,
                        /*child: const Center(
                          child: Orderpage(),
                        ),*/
                      ),
                      
                      
                      // Delivery Tab Content
                      Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text(
                            'Delivery Content',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      // Payroll Tab Content
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Text(
                                  'Payroll Content',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                          // Right panel for Payroll
                          Expanded(
                            child: Container(
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
                            ),
                          ),
                        ],
                      ),
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
              _tabController.animateTo(0);
              break;
            case 'Staff':
              _tabController.animateTo(1);
              break;
            case 'Truck':
              _tabController.animateTo(2);
              break;
            case 'Order':
              _tabController.animateTo(3);
              Navigator.pushNamed(context, 'Orderpage');
              break;
            case 'Delivery':
              _tabController.animateTo(4);
              break;
            case 'Payroll':
              _tabController.animateTo(5);
              break;
            case 'Settings':
              // Handle Settings
              break;
            case 'Log Out':
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Homepage()));
              break;
          }
        });
      },
      onHover: (value) {
        setState(() {
          isSidePanelExpanded =
              value || _tabController.index == menuItems.indexOf(text);
        });
      },
      child: Container(
        height: isSidePanelExpanded ? 50 : 50,
        width: isSidePanelExpanded ? double.infinity : 100,
        color: color, // Background color based on the provided color
        padding: EdgeInsets.symmetric(horizontal: isSidePanelExpanded ? 20 : 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.green,
              size: 35,
            ),
            if (isSidePanelExpanded)
              const SizedBox(width: 20), // Spacing between the icon and title

            if (isSidePanelExpanded)
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 22,
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
        color: Colors.black,
      ),
    );
  }
}

void showResults(BuildContext context) {}



class TabContent extends StatelessWidget {
  final String text;

  const TabContent({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          ElevatedButton(
            onPressed: () {
              // Trigger an update in the parent widget to replace the content of this tab
              _HomepageState parent = context.findAncestorStateOfType<_HomepageState>()!;
              parent.updateTabContent(parent._tabContent.indexOf(this));
            },
            child: const Text('Replace Content'),
          ),
        ],
      ),
    );
  }
}