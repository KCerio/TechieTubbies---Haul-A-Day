import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
//import 'package:haul_a_day_web/authentication/OrderScreen.dart';
//import 'package:haul_a_day_web/page/orderscreen.dart';



class OrderTrial extends StatefulWidget {
  const OrderTrial({Key? key}) : super(key: key);

  @override
  State<OrderTrial> createState() => _OrderTrialState();
}
String selectedFilter = 'Order ID';
class _OrderTrialState extends State<OrderTrial> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      body: Row(
        children: [
          // Left Side Panel (Side Menu Buttons)
          AnimatedContainer(
            width: isSidePanelExpanded ? 200 : 50,
            duration: Duration(milliseconds: 200),
            color: const Color.fromARGB(255, 139, 191, 233),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image at the top with height of 100 and width of 115
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                  child: Image.asset(
                    'images/logo1.jpg', // Change this to your image path
                    height: 100,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ),

                // Separation
                Expanded(child: Container()),

                // Side Menu Buttons
                SizedBox(height: 20),
                sideMenuButton('Home', Color.fromARGB(255, 139, 191, 233), Icons.home),
                sideMenuButton('Staff', Color.fromARGB(255, 139, 191, 233), Icons.people),
                sideMenuButton('Truck', Color.fromARGB(255, 139, 191, 233), Icons.local_shipping),
                sideMenuButton('Order', Color.fromARGB(255, 139, 191, 233), Icons.shopping_cart),
                sideMenuButton('Delivery', Color.fromARGB(255, 139, 191, 233), Icons.delivery_dining),
                sideMenuButton('Payroll', Color.fromARGB(255, 139, 191, 233), Icons.attach_money),

                // Separation
                Expanded(child: Container()),

                // Settings Button
                sideMenuButton('Settings', Color.fromARGB(255, 139, 191, 233), Icons.settings),
              ],
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
                      SizedBox(width: 10), // Add some space



                      // Middle Section (Search bar)
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 235, 232, 232),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 30), //icon inside the search  bar
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  //maxLength: 27, // Limiting to 27 characters
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search order, deliveries and more',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(color: Colors.black),
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
                          SizedBox(width: 10),
                          // Menu icon
                          menuIcon(Icons.menu, Colors.white),
                          SizedBox(width: 10),
                          // Profile picture
                          menuIcon(Icons.account_circle, Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 5, color: Color.fromARGB(255, 235, 173, 4)),

                // Additional text and buttons at the top of the middle section
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Filter By: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Add some space between the texts and the dropdown button
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
                                         SizedBox(width: 80), // Add some space between the "Next" button and "Date" button
                                          // Button for "Date"
                                          TextButton(
                                            onPressed: () => selectDateRange(context),
                                            child: Row(
                                              children: [
                                                Icon(Icons.calendar_today),
                                                SizedBox(width: 8), // Add some space between the icon and text
                                                Text('${startDate.day}-${startDate.month}-${startDate.year} to ${endDate.day}-${endDate.month}-${endDate.year}'),
                                              ],
                                            ),
                                          ),

                                        SizedBox(width: 80), // Add some space between the "Date" button and "Prev" button
                                        // Button for "Prev"
                                        TextButton(
                                          onPressed: goToPrevPage,
                                          child: Row(
                                            children: [
                                              Icon(Icons.arrow_back),
                                              SizedBox(width: 8), // Add some space between the icon and text
                                              Text('Prev'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 20), // Add some space between the "Prev" button and "1-10 of 100" text
                                        // Text "1-10 of 100"
                                        Text('$startIndex-${startIndex + 9} of 100'),
                                        SizedBox(width: 20), // Add some space between the "1-10 of 100" text and "Next" button
                                        // Button for "Next"
                                        TextButton(
                                          onPressed: goToNextPage,
                                          child: Row(
                                            children: [
                                              Text('Next'),
                                              SizedBox(width: 8), // Add some space between the icon and text
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        ),
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
                          color: Color.fromARGB(255, 255, 255, 255),
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
                                            margin: EdgeInsets.fromLTRB(60, 20, 60, 80),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(156, 246, 134, 1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            width: constraints.maxWidth * 0.95, // Adjust the width as a percentage of the parent width
                                            height: constraints.maxHeight * 0.87, // Adjust the height as a percentage of the parent height   
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  //Para ni sa Order Details
                                                    child: GestureDetector(
                                                      onTap:(){
                                                       
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Text(
                                                            'Order ID',
                                                            style: TextStyle(
                                                              fontSize: 20, // Adjust the font size
                                                              fontWeight: FontWeight.bold, // Bold font
                                                              decoration: TextDecoration.underline, // Underline style
                                                              fontFamily: 'Arial',
                                                            ),
                                                            ),
                                                          Text(
                                                            'Customer',
                                                            style: TextStyle(
                                                              fontSize: 20, // Adjust the font size
                                                              fontWeight: FontWeight.bold, // Bold font
                                                              decoration: TextDecoration.underline, // Underline style
                                                              fontFamily: 'Arial',
                                                            ),
                                                            ),
                                                          Text(
                                                            'Cargo Type',
                                                            style: TextStyle(
                                                              fontSize: 20, // Adjust the font size
                                                              fontWeight: FontWeight.bold, // Bold font
                                                              decoration: TextDecoration.underline, // Underline style
                                                              fontFamily: 'Arial',
                                                            ),
                                                            ),
                                                          Text(
                                                            'QTY',
                                                            style: TextStyle(
                                                              fontSize: 20, // Adjust the font size
                                                              fontWeight: FontWeight.bold, // Bold font
                                                              decoration: TextDecoration.underline, // Underline style
                                                              fontFamily: 'Arial',
                                                            ),
                                                            ),
                                                          Text(
                                                            'Total Weight',
                                                            style: TextStyle(
                                                              fontSize: 20, // Adjust the font size
                                                              fontWeight: FontWeight.bold, // Bold font
                                                              decoration: TextDecoration.underline, // Underline style
                                                              fontFamily: 'Arial',
                                                            ),
                                                            ),
                                                          Text(
                                                            'Date Filled',
                                                            style: TextStyle(
                                                              fontSize: 20, // Adjust the font size
                                                              fontWeight: FontWeight.bold, // Bold font
                                                              decoration: TextDecoration.underline, // Underline style
                                                              fontFamily: 'Arial',
                                                            ),
                                                            ),
                                                          Text(
                                                            'Status',
                                                            style: TextStyle(
                                                              fontSize: 20, // Adjust the font size
                                                              fontWeight: FontWeight.bold, // Bold font
                                                              decoration: TextDecoration.underline, // Underline style
                                                              fontFamily: 'Arial',
                                                            ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),      
                                                    ),
                                                    Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: GestureDetector(
                                                    onTap:(){
                                                        
                                                      },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text(
                                                              'Info for Order ID',
                                                              style: TextStyle(
                                                                fontSize: 16, // Adjust the font size
                                                                fontWeight: FontWeight.bold, // Bold font
  
                                                                fontFamily: 'Arial',
                                                              ),
                                                              ),
                                                            Text(
                                                              'Info for Customer',
                                                              style: TextStyle(
                                                                fontSize: 16, // Adjust the font size
                                                                fontWeight: FontWeight.bold, // Bold font
  
                                                                fontFamily: 'Arial',
                                                              ),
                                                              ),
                                                            Text(
                                                              'Info for Cargo Type',
                                                              style: TextStyle(
                                                                fontSize: 16, // Adjust the font size
                                                                fontWeight: FontWeight.bold, // Bold font
  
                                                                fontFamily: 'Arial',
                                                              ),
                                                              ),
                                                            Text(
                                                              'Info for QTY',
                                                              style: TextStyle(
                                                                fontSize: 16, // Adjust the font size
                                                                fontWeight: FontWeight.bold, // Bold font
  
                                                                fontFamily: 'Arial',
                                                              ),
                                                              ),
                                                            Text(
                                                              'Info for Total Weight',
                                                              style: TextStyle(
                                                                fontSize: 16, // Adjust the font size
                                                                fontWeight: FontWeight.bold, // Bold font
  
                                                                fontFamily: 'Arial',
                                                              ),
                                                              ),
                                                            Text(
                                                              'Info for Date Filled',
                                                              style: TextStyle(
                                                                fontSize: 16, // Adjust the font size
                                                                fontWeight: FontWeight.bold, // Bold font
                                                                fontFamily: 'Arial',
                                                              ),
                                                              ),
                                                            Padding(
                                                            padding: const EdgeInsets.all(15.0),
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                   return AlertDialog(
                                                                      contentPadding: EdgeInsets.zero, // Remove default padding
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(15.0),
                                                                      ),
                                                                      content: Stack(
                                                                        children: [
                                                                          Container(    //gi wrap nako sa Stack para sa 'Deploy' button
                                                                            width: 850.0, // Adjust the width as needed
                                                                            height: 600.0, // Adjust the height as needed
                                                                            color: Colors.white, // Set content background color
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xFF3871C1),
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(15.0),
                                                                                      topRight: Radius.circular(15.0),
                                                                                    ),
                                                                                  ),
                                                                                  child: AppBar(
                                                                                    title: Padding(
                                                                                      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
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
                                                                                  padding: const EdgeInsets.fromLTRB(60, 20, 0, 0),
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
                                                                                                Text(
                                                                                                  'Order ID: ',
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 16,
                                                                                                    fontFamily: 'Arial',
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(height: 15),
                                                                                                Text(
                                                                                                  'Order Details',
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 16,
                                                                                                    fontFamily: 'Arial',
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Padding(  //container sulod sa create schedule
                                                                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                                        child: Container(
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
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            'Customer:',
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Arial',
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(width: 10),
                                                                                                          Expanded(
                                                                                                            child: TextField(
                                                                                                              decoration: InputDecoration(
                                                                                                                hintText: 'Enter customer name',
                                                                                                                contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(height: 5),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            'Cargo Type:',
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Arial',
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(width: 10),
                                                                                                          Expanded(
                                                                                                            child: TextField(
                                                                                                              decoration: InputDecoration(
                                                                                                                hintText: 'Enter cargo type',
                                                                                                                contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(height: 5),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            'Weight:',
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Arial',
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(width: 10),
                                                                                                          Expanded(
                                                                                                            child: TextField(
                                                                                                              decoration: InputDecoration(
                                                                                                                hintText: 'Enter weight',
                                                                                                                contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(width: 20),
                                                                                              Expanded(
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.all(25.0),
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            'Date:',
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Arial',
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(width: 10),
                                                                                                          Expanded(
                                                                                                            child: TextField(
                                                                                                              decoration: InputDecoration(
                                                                                                                hintText: 'Enter date',
                                                                                                                contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(height: 5),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            'Time:',
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Arial',
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(width: 10),
                                                                                                          Expanded(
                                                                                                            child: TextField(
                                                                                                              decoration: InputDecoration(
                                                                                                                hintText: 'Enter time',
                                                                                                                contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(height: 5),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            'Location:',
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Arial',
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(width: 10),
                                                                                                          Expanded(
                                                                                                            child: TextField(
                                                                                                              decoration: InputDecoration(
                                                                                                                hintText: 'Enter location',
                                                                                                                contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
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
                                                                                                          Text(
                                                                                                            'Assign Truck:',
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Arial',
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(width: 20),
                                                                                                          Container(
                                                                                                            height: 30,
                                                                                                            width: 300,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: Colors.grey[300],
                                                                                                            ),
                                                                                                            child: DropdownButtonHideUnderline(
                                                                                                              child: DropdownButton<String>(
                                                                                                                items: <String>['Crew 1', 'Crew 2', 'Crew 3', 'Crew 4']
                                                                                                                    .map((String value) {
                                                                                                                  return DropdownMenuItem<String>(
                                                                                                                    value: value,
                                                                                                                    child: Padding(
                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                      child: Text(value),
                                                                                                                    ),
                                                                                                                  );
                                                                                                                }).toList(),
                                                                                                                onChanged: (String? newValue) {
                                                                                                                  // Add your code here to handle the selected value
                                                                                                                },
                                                                                                                icon: Icon(Icons.arrow_drop_down), // Add dropdown icon
                                                                                                                style: TextStyle(
                                                                                                                  fontSize: 14, // Set the font size of the selected item
                                                                                                                  fontFamily: 'Arial',
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(height: 5),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            'Assign Crew 1:',
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Arial',
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(width: 10),
                                                                                                          Container(
                                                                                                            height: 30,
                                                                                                            width: 300,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: Colors.grey[300],
                                                                                                            ),
                                                                                                            child: DropdownButtonHideUnderline(
                                                                                                              child: DropdownButton<String>(
                                                                                                                items: <String>['Crew 1', 'Crew 2', 'Crew 3', 'Crew 4']
                                                                                                                    .map((String value) {
                                                                                                                  return DropdownMenuItem<String>(
                                                                                                                    value: value,
                                                                                                                    child: Padding(
                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                      child: Text(value),
                                                                                                                    ),
                                                                                                                  );
                                                                                                                }).toList(),
                                                                                                                onChanged: (String? newValue) {
                                                                                                                  // Add your code here to handle the selected value
                                                                                                                },
                                                                                                                icon: Icon(Icons.arrow_drop_down), // Add dropdown icon
                                                                                                                style: TextStyle(
                                                                                                                  fontSize: 14, // Set the font size of the selected item
                                                                                                                  fontFamily: 'Arial',
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(height: 5),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            'Assign Crew 2:',
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 16,
                                                                                                              fontFamily: 'Arial',
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(width: 10),
                                                                                                          Container(
                                                                                                            height: 30,
                                                                                                            width: 300,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: Colors.grey[300],
                                                                                                            ),
                                                                                                            child: DropdownButtonHideUnderline(
                                                                                                              child: DropdownButton<String>(
                                                                                                                items: <String>['Crew 1', 'Crew 2', 'Crew 3', 'Crew 4']
                                                                                                                    .map((String value) {
                                                                                                                  return DropdownMenuItem<String>(
                                                                                                                    value: value,
                                                                                                                    child: Padding(
                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                      child: Text(value),
                                                                                                                    ),
                                                                                                                  );
                                                                                                                }).toList(),
                                                                                                                onChanged: (String? newValue) {
                                                                                                                  // Add your code here to handle the selected value
                                                                                                                },
                                                                                                                icon: Icon(Icons.arrow_drop_down), // Add dropdown icon
                                                                                                                style: TextStyle(
                                                                                                                  fontSize: 14, // Set the font size of the selected item
                                                                                                                  fontFamily: 'Arial',
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(height: 25),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Icon(Icons.check_box_outline_blank),
                                                                                                          Text(
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
                                                                                SizedBox(height: 20),
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
                                                                                      },
                                                                                      style: ButtonStyle(
                                                                                        backgroundColor: MaterialStateProperty.all<Color>(
                                                                                            Color.fromARGB(255, 9, 86, 150),
                                                                                          ),
                                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                          RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(8),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      child: Text(
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
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFF3871C1),
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                                child: Text(
                                                                  'Assign',
                                                                  style: TextStyle(
                                                                    fontSize: 16, // Adjust the font size
                                                                    fontWeight: FontWeight.bold, // Bold font
                                                                    fontFamily: 'Arial',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),                                                                               
                                          ),
                                        ],
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
    'Settings'
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
      width: isSidePanelExpanded ? double.infinity : 50,
      color: selectedItem == text ? Colors.grey[300] : color,
      padding: EdgeInsets.symmetric(horizontal: isSidePanelExpanded ? 16 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            iconData,
            color: Colors.green,
            size: 30,
          ),
          if (isSidePanelExpanded)
            SizedBox(width: 10), // Spacing between the icon and title
          if (isSidePanelExpanded)
            Flexible(
              child: Text(
                text,
                style: TextStyle(
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