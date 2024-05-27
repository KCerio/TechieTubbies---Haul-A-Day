import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/models/order_model.dart';
import 'package:haul_a_day_web/trialpage/menupage2.dart';
import 'package:haul_a_day_web/trialpage/order.dart';
import 'package:haul_a_day_web/trialpage/payroll.dart';
import 'package:haul_a_day_web/trialpage/staffList.dart';
import 'package:haul_a_day_web/trialpage/truck_list.dart';
import 'package:haul_a_day_web/trialpage/orderscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:intl/intl.dart';


class DeliveryPage extends StatefulWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

String selectedFilter = 'Order ID';
class _DeliveryPageState extends State<DeliveryPage> with SingleTickerProviderStateMixin {
  int totalItems = 100; // Total number of items
  int itemsPerPage = 10; // Number of items per page
  int startIndex = 1; // Track the start index of the displayed items
  DateTime startDate = DateTime.now(); // Track the start date
  DateTime endDate = DateTime.now(); // Track the end date
  


  Future<void> selectDateRange(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedStartDate != null) {
      final DateTime? pickedEndDate = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: pickedStartDate,
        lastDate: DateTime(2100),
      );
      if (pickedEndDate != null) {
        setState(() {
          startDate = pickedStartDate;
          endDate = pickedEndDate;
          // Add your logic here for filtering data based on the selected date range
        });
      }
    }
  }

  late TabController _tabController;
  String selectedItem = 'Delivery'; // Tracks the selected menu item
  bool isMouseOverHome = false;
  String greetingText = ''; // Local variable for greeting text
  TextEditingController searchController = TextEditingController(); // Search feature that displays a list of words when clicked
  TextEditingController orderController = TextEditingController(); 
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

  //bool Confirm = false;

  
  late List<DataRow>? _rows = [];
  //List<DataRow> _filteredRows = [];

  //get delivery
  Future<void> _fetchData() async {
    List<DataRow> rows =[];
    DatabaseService databaseService = DatabaseService();
    
    await FirebaseFirestore.instance.collection('Order').get().then((snapshot) async {
      for (var orddocument in snapshot.docs)  {
        var orderID = orddocument.id;
        bool status = false;

        // Fetch the 'truckTeam' collection for the current order
        QuerySnapshot statusQuery = await FirebaseFirestore.instance.collection('Order').doc(orderID).collection('truckTeam').get();
        if (statusQuery.docs.isNotEmpty) {
          status = true; // Assigned
          print('Order Delivery : $orderID');
          var orderData = orddocument.data();
          var truck = orderData['assignedTruck'];
          var customer = orderData['company_name'];

          // Fetch the 'LoadingSchedule' collection for the current order
        var loadSnapshot = await FirebaseFirestore.instance.collection('Order').doc(orderID).collection('LoadingSchedule').get();
        for (var loaddocument in loadSnapshot.docs) {
          var loadData = loaddocument.data();
          var date = loadData['loadingTime_Date'].toDate();
          var loadDate = DateFormat('MMM dd, yyyy').format(date);
          var deliveryStatus = loadData['deliveryStatus'];

          rows.add(DataRow(cells: [
                DataCell(
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [Text('$orderID-$truck', textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                        ),
                        )]
                      )
                    )
                  ),
                DataCell(
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [Text(customer, textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                        ),
                        )]
                      )
                    )
                  ),
                DataCell(
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [Text(truck, textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                        ),
                        )]
                      )
                    )
                  ),
                DataCell(
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [Text(loadDate, textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                        ),
                        )]
                      )
                    )
                  ),
                  const DataCell(
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [Text('--', textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                        ),
                        )]
                      )
                    )
                  ),
                  const DataCell(
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [Text('--', textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                        ),
                        )]
                      )
                    )
                  ),
                  DataCell(
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [Text(
                          deliveryStatus == 'On Route'
                              ? 'In Progress'
                              :  'Completed'                                
                        , textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                        ),
                        )]
                      )
                    )
                  ),
                  const DataCell(
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [Text('report', textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                        ),
                        )]
                      )
                    )
                  ),
              ],
              
              ));

              setState(() {
              _rows = rows;
              //_filteredRows = List.from(_rows); // Initialize _filteredRows with _rows
          });
        }

        
        } else {
          status = false; // Not Assigned
        }
      }});

    // Add a DataRow with the retrieved data
      


    
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
    _fetchData();
    //_filteredRows = List.from(_rows);
  }

  /*void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, display all rows
        _filteredRows = List.from(_rows);
      } else {
        // Filter rows based on the search query
        _filteredRows = _rows.where((row) {
          // Check if any cell in the row contains the search query
          return row.cells.any((cell) =>
              cell.child is Text &&
              (cell.child as Text).data!.toLowerCase().contains(query.toLowerCase()));
        }).toList();

        print('Filtered Rows:');
        _filteredRows.forEach((row) {
          print(row);
        });
      }
    });
  }*/



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
        case 4:
          selectedItem = 'Delivery';
          break;
        case 5:
          selectedItem = 'Payroll';
          break;
      }
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
    //_filteredRows = List.from(_rows);
    print("Delivery Row: $_rows");

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

                // Additional text and buttons at the top of the middle section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10,),
                           SizedBox(
                            width: 300,
                            child: TextField(
                              controller: orderController,
                              decoration: const InputDecoration(
                                hintText:
                                    'Search delivery',
                                hintStyle: TextStyle(color: Colors.grey),
                                //border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(color: Colors.black),
                              onChanged: (value) {
                                // Perform search or filtering based on the input
                                setState(() {
                                  //_filterData(orderController.text);
                                });
                              },
                            ),                
                          )
                        ],
                      ),
                      const SizedBox(width: 10), 
                      const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Filter By: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Add some space between the texts and the dropdown button
                      Container(
                        width: 120,
                        child: DropdownButton<String>(
                          value: selectedFilter,
                          onChanged: (String? newValue) {
                                            setState(() {
                          selectedFilter = newValue!;
                                            });
                                            },
                                            items: <String>[
                                              'Order ID', 
                                              'Customer', 
                                              'Cargo Type', 
                                              'QTY', 
                                              'Total Weight', 
                                              'Date Filled', 
                                              'Status'
                                              ]
                                              .map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            dropdownColor: Colors.grey[300],
                                          ),
                                         ),
                                         const SizedBox(width: 80), // Add some space between the "Next" button and "Date" button
                                          // Button for "Date"
                                          TextButton(
                                            onPressed: () => selectDateRange(context),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.calendar_today),
                                                const SizedBox(width: 8), // Add some space between the icon and text
                                                Text('${startDate.day}-${startDate.month}-${startDate.year} to ${endDate.day}-${endDate.month}-${endDate.year}'),
                                              ],
                                            ),
                                          ),

                                        const SizedBox(width: 10), // Add some space between the "Date" button and "Prev" button
                                       
                                       ],
                                     ),
                                    ),

                // Main Content
                Expanded(
                  child: Row(
                    children: [
                      // Middle Content (Placeholder)
                      Expanded(
                        flex: 4,
                        child: Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
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
                                  builder: (context, constraints) {
                                    return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(60, 20, 60, 60),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(156, 246, 134, 1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            width: constraints.maxWidth * 0.80, // Adjust the width as a percentage of the parent width
                                            height: constraints.maxHeight * 0.85, // Adjust the height as a percentage of the parent height   
                                            child: Container(
                                              alignment: Alignment.topCenter,
                                              child: Expanded(
                                                child: Scrollbar(
                                                  thumbVisibility: true,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: SingleChildScrollView(
                                                        scrollDirection: Axis.vertical,
                                                        child: DataTable(
                                                          showCheckboxColumn: false,
                                                          columns: const [
                                                            DataColumn(label: 
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center, 
                                                                children: [Text('Delivery ID', 
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                )]
                                                                )
                                                              )
                                                            ),
                                                            DataColumn(label: 
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center, 
                                                                children: [Text('Customer', textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                )]
                                                                )
                                                              )
                                                            ),
                                                            DataColumn(label: 
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center, 
                                                                children: [Text('Truck Team', textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                )]
                                                                )
                                                              )
                                                            ),
                                                            DataColumn(label: 
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center, 
                                                                children: [Text('Loading Date', textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                )]
                                                                )
                                                              )
                                                            ),
                                                            DataColumn(label: 
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center, 
                                                                children: [Text('Start At',  textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                )]
                                                                )
                                                              )
                                                            ),
                                                            DataColumn(label: 
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center, 
                                                                children: [Text('End At',  textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                )]
                                                                )
                                                              )
                                                            ),
                                                            DataColumn(label: 
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center, 
                                                                children: [Text('Status', textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                )]
                                                                )
                                                              )
                                                            ),
                                                            DataColumn(label: 
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center, 
                                                                children: [Text('Report', textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                )]
                                                                )
                                                              )
                                                            ),
                                                          ],
                                                          rows: _rows ?? [], // Populate rows with data
                                                        ),
                                                      ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          )
                                       ]
                                    );
                                  }
                                ),
                          ),
                        ),
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
    'Log out'
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
