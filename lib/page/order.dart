import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/models/order_model.dart';
import 'package:haul_a_day_web/page/delivery.dart';
import 'package:haul_a_day_web/page/payroll.dart';
import 'package:haul_a_day_web/page/staffList.dart';
import 'package:haul_a_day_web/page/truck_list.dart';
import 'package:haul_a_day_web/page/menupage2.dart';
import 'package:haul_a_day_web/page/orderscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:intl/intl.dart';


class Orderpage extends StatefulWidget {
  const Orderpage({Key? key}) : super(key: key);

  @override
  State<Orderpage> createState() => _OrderpageState();
}
String selectedFilter = 'Order ID';
class _OrderpageState extends State<Orderpage> with SingleTickerProviderStateMixin {
  int totalItems = 100; // Total number of items
  int itemsPerPage = 10; // Number of items per page
  int startIndex = 1; // Track the start index of the displayed items
  DateTime startDate = DateTime.now(); // Track the start date
  DateTime endDate = DateTime.now(); // Track the end date

  void goToPrevPage() {
    setState(() {
      if (startIndex > 1) {
        startIndex -= itemsPerPage; // Update the start index for previous page
      }
    });
  }

  void goToNextPage() {
    setState(() {
      if (startIndex + itemsPerPage <= totalItems) {
        startIndex += itemsPerPage; // Update the start index for next page
      }
    });
  }

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
  String selectedItem = 'Order'; // Tracks the selected menu item
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

  
  List<DataRow> _rows = [];
  List<DataRow> _filteredRows = [];
  //List<DataRow> _allRows = [];

  //get order
  Future<void> _fetchData() async {
    List<DataRow> rows =[];
    
    await FirebaseFirestore.instance.collection('Order').get().then((snapshot) async {
      for (var orddocument in snapshot.docs) {
        var orderData = orddocument.data();
        var orderID = orddocument.id;
        var customer = orderData['company_name'];
        var date_filed = orderData['date_filed'].toDate();
        var orderDate = DateFormat('MMM dd, yyyy').format(date_filed);
        //var orderTime = DateFormat('HH:mm').format(date_filed);
        bool confirmed = orderData['confirmed_status'];

        bool status = false;

        // Fetch the 'truckTeam' collection for the current order
        QuerySnapshot statusQuery = await FirebaseFirestore.instance.collection('Order').doc(orderID).collection('truckTeam').get();
        if (statusQuery.docs.isNotEmpty) {
          status = true; // Assigned
        } else {
          status = false; // Not Assigned
        }

        // Fetch the 'LoadingSchedule' collection for the current order
        var loadSnapshot = await FirebaseFirestore.instance.collection('Order').doc(orderID).collection('LoadingSchedule').get();
        for (var loaddocument in loadSnapshot.docs) {
          var loadData = loaddocument.data();
          var loadID = loaddocument.id;
          var cargoType = loadData['cargoType'];
          var quantity = loadData['totalCartons'];

          // Fetch the 'UnloadingSchedule' collection for the current load
          var unloadSnapshot = await FirebaseFirestore.instance.collection('Order').doc(orderID).collection('LoadingSchedule').doc(loadID).collection('UnloadingSchedule').get();
          int weight = 0;
          for (var unloaddocument in unloadSnapshot.docs) {
            var unloadData = unloaddocument.data();
            int subWeight = unloadData['weight'];
            weight += subWeight;
          }

          // Conditionally define the status widget
          Widget statusWidget = status
              ? ElevatedButton(
                  onPressed: (){
                    // Button is disabled if order is already confirmed
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Error"),
                        content: const Text("Order Already Assigned!"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
                  ), // Button is disabled if status is true
                  child: const Text('Assign',
                  style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    // Create Schedule Window
                    if (confirmed == false) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("Order Not Confirmed!"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (confirmed == true) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            content: AssignDialog(orderId: orderID,weight: weight,),
                          );
                        },
                      );
                    }

                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 56,113,193)),
                    foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  child: const Text('Assign',
                  style: TextStyle(
                      fontSize: 16,
                    ),
                    ),
                );

          
          // Add a DataRow with the retrieved data
          rows.add(DataRow(cells: [
            DataCell(
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [Text(orderID, textAlign: TextAlign.center,
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
                  children: [Text(cargoType, textAlign: TextAlign.center,
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
                  children: [Text(quantity.toString(), textAlign: TextAlign.center,
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
                  children: [Text(weight.toString(), textAlign: TextAlign.center,
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
                  children: [Text(orderDate.toString(), textAlign: TextAlign.center,
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
                  children: [statusWidget]
                  )
                )
              ),
          ],
          selected: false, // Remove the checkbox
          onSelectChanged: (_){
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (context) => 
                      OrderScreen(orderId: orderID,status: status)
              ));
                      //OrderDetailsPage(orderId: orderID,)));
          }
          ));

          setState(() {
          _rows = rows;
          _filteredRows = List.from(_rows); // Initialize _filteredRows with _rows
      });
        }
      }
    }).catchError((error) {
      print('Error: $error');
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
    

    _fetchData();
    //_filteredRows = List.from(_rows);
  }

  void filterRows(List<DataRow> rows, String query) {
    // Convert the query to lowercase for case-insensitive matching
    String lowercaseQuery = query.toLowerCase();

    // Filter the rows based on the search query
    List<DataRow> filteredRows = rows.where((row) {
      // Iterate through each cell in the row
      for (DataCell cell in row.cells) {
        // Extract text data from the cell
        String cellText = ((cell.child as Expanded).child as Row).children[0].toString().toLowerCase(); // Adjust this according to your actual structure

        // Check if the cell text contains the search query
        if (cellText.contains(lowercaseQuery)) {
          // If any cell contains the query, return true to include the row
          return true;
        }
      }
      // If none of the cells contain the query, return false to exclude the row
      return false;
    }).toList();

    print("Filter Rows: $filteredRows \nLength: ${filteredRows.length}");
    setState(() {
      _filteredRows = filteredRows;
    }); 
  }

  void sortData(String selectedFilter) {
    setState(() {
      switch (selectedFilter) {
        case 'Order ID':
          _filteredRows.sort((a, b) {
            // Access the Text widget within the Row and convert its content to string
            String textA = ((a.cells[0].child as Expanded).child as Row).children.first.toString();
            String textB = ((b.cells[0].child as Expanded).child as Row).children.first.toString();
            
            // Compare the textual representation of the content
            return textA.compareTo(textB);
          });
          break;
        case 'Customer':
          _filteredRows.sort((a, b) {
            // Access the Text widget within the Row and convert its content to string
            String textA = ((a.cells[1].child as Expanded).child as Row).children.first.toString();
            String textB = ((b.cells[1].child as Expanded).child as Row).children.first.toString();
            
            // Compare the textual representation of the content
            return textA.compareTo(textB);
          });
          break;
        case 'Cargo Type':
          _filteredRows.sort((a, b) {
            // Access the Text widget within the Row and convert its content to string
            String textA = ((a.cells[2].child as Expanded).child as Row).children.first.toString();
            String textB = ((b.cells[2].child as Expanded).child as Row).children.first.toString();
            
            // Compare the textual representation of the content
            return textA.compareTo(textB);
          });
          break;
        case 'QTY':
        _filteredRows.sort((a, b) {
          // Access the Text widget within the Row and convert its content to string
          String textA = ((a.cells[3].child as Expanded).child as Row).children.first.toString();
          String textB = ((b.cells[3].child as Expanded).child as Row).children.first.toString();
          
          // Parse the string representation as an integer for comparison
          int valueA = int.parse(textA);
          int valueB = int.parse(textB);
          print('$valueA, $valueB');
          // Compare the integer values
          return valueA.compareTo(valueB);
        });
        break;
      case 'Total Weight':
        _filteredRows.sort((a, b) {
          // Access the Text widget within the Row and convert its content to string
          String textA = ((a.cells[4].child as Expanded).child as Row).children.first.toString();
          String textB = ((b.cells[4].child as Expanded).child as Row).children.first.toString();
          
          // Parse the string representation as an integer for comparison
          int valueA = int.parse(textA);
          int valueB = int.parse(textB);
          
          // Compare the integer values
          return valueA.compareTo(valueB);
        });
        break;
        /*'QTY', 
                            'Total Weight', */ 
        // Add cases for other filters similarly...
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
    //print("Filtered Row: $_filteredRows");

    return Scaffold(
      body: Row(
        children: [
          // Left Side Panel (Side Menu Buttons)
          Container(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              width: isSidePanelExpanded ? 190 : 90,
              duration: Duration(milliseconds: 200),
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
                                    'Search order',
                                hintStyle: TextStyle(color: Colors.grey),
                                //border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(color: Colors.black),
                              onChanged: (value) {
                                // Perform search or filtering based on the input
                                setState(() {
                                  filterRows(_rows,orderController.text);
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
                              sortData(newValue);
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
                                        // Button for "Prev"
                                        /*TextButton(
                                          onPressed: goToPrevPage,
                                          child: const Row(
                                            children: [
                                              Icon(Icons.arrow_back),
                                              SizedBox(width: 8), // Add some space between the icon and text
                                              Text('Prev'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20), // Add some space between the "Prev" button and "1-10 of 100" text
                                        //Text "1-10 of 100"
                                        Text('$startIndex-${startIndex + 9} of 100'),
                                        const SizedBox(width: 20), // Add some space between the "1-10 of 100" text and "Next" button
                                        // Button for "Next"
                                        TextButton(
                                          onPressed: goToNextPage,
                                          child: const Row(
                                            children: [
                                              Text('Next'),
                                              SizedBox(width: 8), // Add some space between the icon and text
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        ),*/
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
                                                                children: [Text('Order ID', 
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
                                                                children: [Text('Cargo Type', textAlign: TextAlign.center,
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
                                                                children: [Text('Quantity (ctns)', textAlign: TextAlign.center,
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
                                                                children: [Text('Weight (kg)',  textAlign: TextAlign.center,
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
                                                                children: [Text('Date Filed',  textAlign: TextAlign.center,
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
                                                          ],
                                                          rows:  _filteredRows, // Populate rows with data
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

//the search scrollable list for the user to choose from
//the transparent image
//the search bar sized box
//


class AssignDialog extends StatefulWidget {
  final String orderId;
  final int weight;
  const AssignDialog({super.key, required this.orderId, required this.weight});

  @override
  State<AssignDialog> createState() => _AssignDialogState();
}

class _AssignDialogState extends State<AssignDialog> {

  DatabaseService databaseService = DatabaseService();
  Map<String, dynamic> _orderDetails = {};
  Map<String, dynamic> _loadingDetails = {};
  bool isCheck = false;
  List<String> _truckAvailable = [];
  List<String> _helpersAvailable = [];
  String? _selectedTruck;
  String? _selectedCrew1;
  String? _selectedCrew2;
  
  @override
  void initState(){
    super.initState();
    getDetails();
    
  }

  Future<void> getDetails()async{
  // Fetch order details
  try {
    Map<String, dynamic> orderDetails = await databaseService.fetchOrderDetails(widget.orderId);
    Map<String, dynamic> loadingDetails = await databaseService.fetchLoadingSchedule(widget.orderId);
    List<String> truckAvailable = await databaseService.getAvailableTruckDocumentIds(loadingDetails['cargoType']);
    List<String> helpersAvailable = await databaseService.getAvailableCrewIds();
    setState(() {
      _orderDetails = orderDetails;
      _loadingDetails = loadingDetails;
      _truckAvailable = truckAvailable;
      _helpersAvailable = helpersAvailable;
    });
  } catch (e) {
    print('Failed to fetch order details: $e');
  }
    
  }

  @override
  Widget build(BuildContext context) {
    print(_orderDetails);
    print(_loadingDetails);
    print("\nhelpers: $_helpersAvailable");
    
    return Stack(
      children: [
        Container(    //gi wrap nako sa Stack para sa 'Deploy' button
          width: 850.0, // Adjust the width as needed
          height: 600.0, // Adjust the height as needed
          color: Colors.white, // Set content background color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF3871C1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: AppBar(
                  title: const Padding(
                    padding: EdgeInsets.fromLTRB(250, 0, 0, 0),
                    child: Text(
                      'Create Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.amber,
                  elevation: 0, // Remove the shadow
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [                          
                              const Text(
                                'Order Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              //SizedBox(height: 15),
                              Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Order ID: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.orderId,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Arial',
                                  ),
                                ),
                              ],
                            ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(  //container sulod sa create schedule
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 210,
                        width: 740,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Customer:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${_orderDetails['company_name'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'Cargo Type:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          _loadingDetails['cargoType'] == 'fgl'
                                            ? 'frozen cargo'
                                            : _loadingDetails['cargoType'] == 'cgl'
                                                ? 'dry cargo'
                                                : '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'Weight:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${widget.weight} kgs',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Date:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${_loadingDetails['date'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'Time:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${_loadingDetails['time'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'Route:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${_loadingDetails['route'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(100, 20, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Assign Truck:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Container(
                                          height: 40,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _selectedTruck,
                                              items: _truckAvailable.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(value),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedTruck = newValue;
                                                  //truck = _selectedCrew1!;
                                                });
                                                // Add your code here to handle the selected value
                                              },
                                              icon: const Icon(Icons.arrow_drop_down), // Add dropdown icon
                                              style: const TextStyle(
                                                fontSize: 14, // Set the font size of the selected item
                                                fontFamily: 'Arial',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          'Assign Crew 1:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          height: 40,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _selectedCrew1,
                                              onChanged: (String? newValue) {
                                                // Add your code here to handle the selected value
                                                setState(() {
                                                  _selectedCrew1 = newValue; 
                                                  //crew1 = newValue!;                                                                 
                                                });
                                                // Remove selected crew from the list
                                                //_helpersAvailable.remove(_selectedCrew1);
                                                
                                              },
                                              items: _helpersAvailable.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(value),
                                                  ),
                                                );
                                              }).toList(),                                
                                              icon: const Icon(Icons.arrow_drop_down), // Add dropdown icon
                                              style: const TextStyle(
                                                fontSize: 14, // Set the font size of the selected item
                                                fontFamily: 'Arial',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          'Assign Crew 2:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          height: 40,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _selectedCrew2,
                                              onChanged: (String? newValue) {
                                                // Add your code here to handle the selected value
                                                setState(() {                                                  
                                                  _selectedCrew2 = newValue;
                                                  //crew2 = newValue!;                                                  
                                                });
                                                // Remove selected crew from the list
                                                //_helpersAvailable.remove(_selectedCrew2);
                                                
                                              },
                                              items:_selectedCrew1 != null
                                                ? _helpersAvailable.where((element) => element != _selectedCrew1).map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(value),
                                                      ),
                                                    );
                                                  }).toList()
                                                : _helpersAvailable.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(value),
                                                      ),
                                                    );
                                                  }).toList(),                                  
                                              icon: const Icon(Icons.arrow_drop_down), // Add dropdown icon
                                              style: const TextStyle(
                                                fontSize: 14, // Set the font size of the selected item
                                                fontFamily: 'Arial',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 25),
                                    Row(
                                      children: [
                                        Checkbox(
                                        value: isCheck,
                                        onChanged: (newValue) {
                                          setState(() {
                                            isCheck = newValue!;
                                          });
                                        },
                                      ),
                                        const Text(
                                          'Confirm Schedule',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
              const SizedBox(height: 20),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                      if(_selectedTruck == null ||
                          _selectedCrew1 == null ||
                          _selectedCrew2 == null ||
                          !isCheck){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('Please fill all dropdowns and check the checkbox to confirm schedule.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }else{
                        String orderId = widget.orderId;
                        String truck = _selectedTruck!;
                        String crew1 = _selectedCrew1!;
                        String  crew2 = _selectedCrew2!;

                        print('Assign Schedule to: $orderId, $truck, $crew1, $crew2');
                        databaseService.assignSchedule(widget.orderId, truck,crew1,crew2);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Assigned Successful'),
                              content:  Text('Schedule successfully assigned to $truck.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.push( 
                                      context, 
                                      MaterialPageRoute( 
                                          builder: (context) => 
                                              const Orderpage()));
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        //Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 9, 86, 150),
                        ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Deploy',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}