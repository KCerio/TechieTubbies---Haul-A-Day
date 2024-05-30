import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/trialpage/delivery.dart';
import 'package:haul_a_day_web/trialpage/order.dart';
import 'package:haul_a_day_web/trialpage/menupage2.dart';
import 'package:haul_a_day_web/trialpage/payroll.dart';
import 'package:haul_a_day_web/trialpage/truck_list.dart';
import 'package:haul_a_day_web/service/database.dart';

class StaffList extends StatefulWidget {
  const StaffList({super.key});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedItem = 'Staff'; // Tracks the selected menu item
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

  bool showStaffContainer = true;
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
    _initializeStaffData();
  }

  List<Map<String, dynamic>> _staffs = [];
  Map<String, dynamic> selectedStaff = {};
  bool selectaStaff = false;

  Future<void> _initializeStaffData() async {
    try {
      DatabaseService databaseService = DatabaseService();
      List<Map<String, dynamic>> staffs = await databaseService.fetchOPStaffList();
      setState(() {
        _staffs = staffs;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
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
                                        //Left Side of Staff List
                                        Container(
                                          width: size.width *0.5,
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
                                                      child: const Text(
                                                        'Remove Employee',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
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
                                                      child: const Text(
                                                        'Add New Employee',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Expanded(
                                                child: _staffs.isEmpty ?  Container(height: size.height*0.8,alignment: Alignment.center,child: CircularProgressIndicator()) 
                                                : SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [

                                                        //thy list creates the containers for all the trucks
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                                          itemCount: _staffs.length,
                                                          itemBuilder: (context, index) {
                                                            return buildStaffContainer(_staffs[index]);
                                                          },
                                                        ),
                                                      ],
                                                    )

                                                )
                                            ),
                                              const SizedBox(height: 10),
                                            ]
                                          ),

                                        ),
                                        // Right panel for Staff
                                        Expanded(
                                          child: selectaStaff == true 
                                          ? staffPanel(selectedStaff)
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
  //container decor
  //for the list
  Widget buildStaffContainer(Map<String, dynamic> aStaff){
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
            backgroundImage: AssetImage('images/user_pic.png'),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                '${aStaff['firstname']} ${aStaff['lastname']}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.black),
              ),
              Text(
                'Staff ID: ${aStaff['staffId']}',
                style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.black),
              ),
              Text(
                'Position: ${aStaff['position']}',
                style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.black),
              ),
              Text(
                'Schedule: ${
                  aStaff['assignedSchedule'] == 'none' || aStaff['assignedSchedule'] == null
                    ? 'No Assigned Schedule'        
                      : aStaff['assignedSchedule']
                }',
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
                
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if(selectaStaff == false){
                        selectedStaff = aStaff;
                        selectaStaff = true;
                      }
                      else if(selectaStaff == true){
                        selectedStaff = {};
                        selectaStaff = false;
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
                    /*selectaStaff
                        ? Colors
                        .blue
                        : Colors
                        .blue
                        .shade200,*/
                    foregroundColor:Colors.white,
                    /*selectaStaff
                        ? Colors
                        .white
                        : Colors
                        .black*/
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

  // unselected Right Panel
  Widget unselectedRightPanel(){
    return Expanded(
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
    );
  }

  // selected staff right panel
  Widget staffPanel(Map<String, dynamic> aStaff){
    Size size = MediaQuery.of(context).size;
    return Container(
                width: size.width *0.5,
                color: Colors.green.shade50,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              size: 35, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              if(selectaStaff == false){
                                selectedStaff = aStaff;
                                selectaStaff = true;
                              }
                              else if(selectaStaff == true){
                                selectedStaff = {};
                                selectaStaff = false;
                              }
                            });
                          },
                        ),
                        // Add other widgets to the app bar as needed
                      ],
                    ),
                      SizedBox(height: 40),
                      Positioned(
                        left: 100,
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'images/user_pic.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${aStaff['firstname']} ${aStaff['lastname']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 250,
                        color: Colors.grey.shade400,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Staff ID: ${aStaff['staffId']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text('Username: ${aStaff['userName']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text('Position: ${aStaff['position']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text('Registered Date: ${aStaff['registeredDate']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text('Contact Number: ${'contactNumber'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text('Email',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(100, 50, 0, 30),
                          child: ElevatedButton(
                            onPressed: () {
                              // Remove truck functionality here
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(2),
                                  right: Radius.circular(2),
                                ),
                              ),
                              backgroundColor: Colors
                                  .grey[300], // Background color of the button
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}

//the search scrollable list for the user to choose from
//the transparent image
//the search bar sized box
//

