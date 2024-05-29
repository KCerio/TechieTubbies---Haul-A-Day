import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/trialpage/delivery.dart';
import 'package:haul_a_day_web/trialpage/menupage2.dart';
import 'package:haul_a_day_web/trialpage/payroll.dart';
import 'package:haul_a_day_web/trialpage/staffList.dart';
import 'package:haul_a_day_web/trialpage/truck_list.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/service/date.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/trialpage/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';



class OrderScreen extends StatefulWidget {
  final String  orderId;
  final bool status;
  OrderScreen ({super.key, required this.orderId,required this.status});

  @override
  State<OrderScreen > createState() => _OrderScreenState();
}
String selectedFilter = 'Order ID';
class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
 
  late TabController _tabController;
  String selectedItem = 'Order'; // Tracks the selected menu item
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
  //var orderId = widget.orderId.toString();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchData(widget.orderId);

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

  DatabaseService databaseService = DatabaseService();
  Map<String, dynamic> _orderDetails = {};
  Map<String, dynamic> _loadingDetails = {};
  bool confirm = true;

  //get loading details
  Future<void> _fetchData(String orderId) async {
  try {
    Map<String, dynamic> orderDetails = await databaseService.fetchOrderDetails(widget.orderId);
    Map<String, dynamic> loadingDetails = await databaseService.fetchLoadingSchedule(widget.orderId);
    //String status  = databaseService.getDeliveryStatus(orderId).toString();
    setState(() {
      _orderDetails = orderDetails;
      _loadingDetails = loadingDetails;
      //_status = status;
      confirm = orderDetails['confirmed_status'];
    });
  } catch (e) {
    print('Failed to fetch order details: $e');
  }
}

  // updating confirmation status
  void updateFirestoreValue() async {
    // Get a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Update the value of a document in Firestore
      // ignore: avoid_single_cascade_in_expression_statements
      firestore..collection('Order').doc(widget.orderId).update({
        'confirmed_status': !confirm,
      });
      print('Document successfully updated');
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    print(_orderDetails);
    print(_loadingDetails);
    //print('Status: $_status');

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
              

                // Main Content
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () {
                                        Navigator.push( 
                                          context, 
                                          MaterialPageRoute( 
                                              builder: (context) => 
                                                  const Orderpage()));
                                      },
                                      iconSize: 30.0,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 10,),
                                    const Text("Order Details",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green
                                    ),
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                                    return SingleChildScrollView( //para ni di maguba ang pixel
                                      //physics: NeverScrollableScrollPhysics(),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(            //first container
                                              margin: const EdgeInsets.fromLTRB(60, 10, 60, 20),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE1E1E1),
                                              ),
                                              width: size.width * 0.85, // Adjust the width as a percentage of the parent width
                                              height: size.height * 0.60, // Adjust the height as a percentage of the parent height   
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(70, 20, 0, 70),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Order ID: ${widget.orderId}',
                                                          style: const TextStyle(
                                                            fontSize: 16, 
                                                            color: Colors.black
                                                            ),
                                                        ),
                                                        const Spacer(), // Add a spacer widget to push the button to the end
                                                        //bool isConfirmed = false;

                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                                          child: ElevatedButton(
                                                            onPressed: confirm
                                                                ? (){
                                                                  // Button is disabled if order is already confirmed
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (_) => AlertDialog(
                                                                        title: const Text("Error"),
                                                                        content: const Text("Order Already Confirmed!"),
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
                                                                  
                                                                } 
                                                                : () {
                                                                    setState(() {
                                                                      confirm = true; // Set the flag to true when the button is clicked
                                                                    });
                                                                    updateFirestoreValue();
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (_) => AlertDialog(
                                                                        title: const Text("Confirmation"),
                                                                        content: const Text("Order confirmed!"),
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
                                                              backgroundColor: confirm
                                                                  ? MaterialStateProperty.all<Color>(Colors.grey) // Gray out the button if confirmed
                                                                  : MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 235, 59)),
                                                              foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                                                            ),
                                                            child: const Text(
                                                              'Confirm',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        const  SizedBox(width: 20),

                                                        
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(1, 0, 70, 20),
                                                          child: ElevatedButton(
                                                            onPressed: confirm
                                                                ? (){
                                                                  // Button is disabled if order is already confirmed
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (_) => AlertDialog(
                                                                        title: const Text("Alert"),
                                                                        content: const Text("Do you wish to cancel confirmation or remove the order completely?"),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                confirm = !confirm; 
                                                                              });
                                                                              updateFirestoreValue();
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child: const Text('Cancel Confirmation'),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child: const Text('Remove Order'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  
                                                                } 
                                                                : (){

                                                                
                                                              
                                                            },
                                                            style: ButtonStyle(
                                                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                                                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255,235,59)),
                                                              foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255,0,0,0)),
                                                            ),
                                                            child: const Text('Cancel',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                              ),
                                                          ),
                                                        ),                                                     
                                                      ],
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 10), // Adjusted left padding
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.person), // Icon before Customer text
                                                          SizedBox(width: 8), // Space between icon and text
                                                          Text(
                                                            'Customer',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 300), // Adjusted left padding for Order Info
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.info), // Icon before Order Info text
                                                                SizedBox(width: 8), // Space between icon and text
                                                                Text(
                                                                  'Order Info',
                                                                  style: TextStyle(
                                                                    fontSize: 20,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                     Padding(
                                                      padding: const EdgeInsets.only(top:1),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 50),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(                                                                  
                                                                      'Company Name: ${_orderDetails['company_name'] ?? ''}',  
                                                                      style: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.black,
                                                                        ),
                                                                    ),
                                                                Text(
                                                                      'Point Person: ${_orderDetails['point_person'] ?? ''}', 
                                                                      style: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.black,
                                                                        ),
                                                                    ),
                                                                    Text(
                                                                      'Email: ${_orderDetails['customer_email'] ?? ''}', 
                                                                      style: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.black,
                                                                        ),
                                                                    ),
                                                                    Text(
                                                                      'Phone: ${_orderDetails['phone'] ?? ''}', 
                                                                      style: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.black,
                                                                        ),
                                                                    ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Padding(
                                                            padding: const EdgeInsets.only( right: 70),
                                                            child: SizedBox(
                                                                  height: 100,
                                                                  width: 300,
                                                                  child: DecoratedBox(
                                                                  decoration: const BoxDecoration(
                                                                    color: Color.fromARGB(0, 255, 255, 255)
                                                              ),
                                                              child:Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,   
                                                              children: [
                                                                Text(
                                                                  'Location: ${_loadingDetails['warehouse'] ?? ''}, ${ _loadingDetails['loadingLocation'] ?? ''} ',  // Example name
                                                                  style: const TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                                
                                                                Text(
                                                                  'Time: ${_loadingDetails['time'] ?? ''}',  // Example phone number
                                                                  style: const TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Date: ${_loadingDetails['date'] ?? ''}',  // Example phone number
                                                                  style: const TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            ),
                                                          )                      
                                                          ),                                                         
                                                        ],
                                                      ),                                                          
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 10), // Adjusted left padding
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.local_shipping), // Icon before Customer text
                                                          SizedBox(width: 8), // Space between icon and text
                                                          Text(
                                                            'Delivery Info',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 335,top: 5), // Adjusted left padding for Order Info
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.note), // Icon before Order Info text
                                                                SizedBox(width: 8), // Space between icon and text
                                                                Text(
                                                                  'Notes',
                                                                  style: TextStyle(
                                                                    fontSize: 20,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                            
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 1),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:50),
                                                            child: Column(                                                              
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      'Status: ',
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      widget.status == true
                                                                        ? 'In Progress'
                                                                        : widget.status == false
                                                                          ? 'To be Assigned'
                                                                          : '',  
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: widget.status == true
                                                                          ? const Color.fromARGB(255, 42, 147, 45) // Color green for 'In Progress'
                                                                          : widget.status == false
                                                                            ? const Color.fromARGB(255, 246, 208, 55) // Color yellow for 'To be Assign'
                                                                            : Colors.black, // Default color for other cases 
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),


                                                                const Text(
                                                                      'Truck ID: ',
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.black,
                                                                        ),
                                                                    ),
                                                                    const Text(
                                                                      'Truck Driver: ',
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.black,
                                                                        ),
                                                                    ),
                                                                    const Text(
                                                                      'Truck Crew: ',
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: Colors.black,
                                                                        ),
                                                                    ),
                                                                  ],
                                                                ),
                                                          ),
                                                          const Spacer(),
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 70, top: 5),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 100,
                                                                  width: 300,
                                                                  child: DecoratedBox(
                                                                    decoration: const BoxDecoration(
                                                                      color: Colors.white,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0), // Example inset values
                                                                      child: Text(
                                                                        '${_orderDetails['note'] ?? ''}',
                                                                        style: const TextStyle(
                                                                          fontSize: 16,
                                                                          color: Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                                                               
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
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(60, 0.01, 60, 40),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE1E1E1),
                                              ),
                                              width: size.width * 0.85,
                                              height: size.height * 0.60,
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.fromLTRB(40, 20, 0, 5),
                                                      child: Text(
                                                        'Unloading Details',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold, 
                                                          color: Colors.black
                                                        ),
                                                      ),
                                                    ),
                                                   Expanded(child: UnloadingSchedule(orderId: widget.orderId),), // Unlaoding widget
                                                   const SizedBox(height: 20),
                                          ],
                                        ),
                                    )
                                          ]
                                    )
                                    );
                                  }
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



//Unloading Schedule of a specific order
class UnloadingSchedule extends StatefulWidget {
  final String orderId;
  const UnloadingSchedule({required this.orderId});

  @override
  State<UnloadingSchedule> createState() => _UnloadingScheduleState();
}

class _UnloadingScheduleState extends State<UnloadingSchedule> {
  late List<DataRow>? _rows = [];

  @override
  void initState() {
    super.initState();
    _fetchData(widget.orderId);
  }

  //get unloading shedule details for the unloading table
  Future<void> _fetchData(String orderId) async {
    List<DataRow> rows =[];

    await FirebaseFirestore.instance
    .collection('Order')
    .doc(orderId)
    .collection('LoadingSchedule')
    .limit(1)
    .get()
    .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        var firstDocument = snapshot.docs.first;
        var loadData = firstDocument.data();
        var cargoType = loadData['cargoType'];

        var loadingScheduleCollection = firstDocument.reference
            .collection('UnloadingSchedule'); // Accessing the subcollection
        // Retrieve data from all documensts in the "UnloadingSchedule" collection
        loadingScheduleCollection.get().then((snapshot) async {
        for (var document in snapshot.docs) {
          var unloadId = document.id;
          var unloadData = document.data();
          var recipient = unloadData['recipient'];
          var ref_no = unloadData['reference_num'];
          var weight = unloadData['weight'];
          var quantity = unloadData['quantity'];
          var location = unloadData['unloadingLocation'];
          var date = unloadData['unloadingTimestamp'].toDate();
          var unloadDate = DateFormat('MMM dd, yyyy').format(date);
          var time = DateFormat('HH:mm a').format(date);
          print("$unloadId,$recipient, $ref_no, $weight, $location\n");

        // Add a DataRow with the retrieved data
        rows.add(DataRow(cells: [
          DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(recipient, textAlign: TextAlign.center,)]
                )
              )
            ),
          DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(ref_no.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
          DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(cargoType, textAlign: TextAlign.center)]
                )
              )
            ),
          DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(weight.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
            DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(quantity.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
            DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(location, textAlign: TextAlign.center)]
                )
              )
            ),
            DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(unloadDate.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
            DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(time.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
        ]
        ));

        
          }
        setState(() {
        _rows = rows;
        });
      }).catchError((error) {
        print('Error: $error');
      });
  }});
}


  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.topCenter,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: 
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [Text('RECIPIENT', textAlign: TextAlign.center,)]
                          )
                        )
                      ),
                      DataColumn(label: 
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [Text('REFERENCE NO.', textAlign: TextAlign.center,)]
                          )
                        )
                      ),
                      DataColumn(label: 
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [Text('CARGO TYPE', textAlign: TextAlign.center,)]
                          )
                        )
                      ),
                      DataColumn(label: 
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [Text('WEIGHT', textAlign: TextAlign.center,)]
                          )
                        )
                      ),
                      DataColumn(label: 
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [Text('QUANTITY', textAlign: TextAlign.center,)]
                          )
                        )
                      ),
                      DataColumn(label: 
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [Text('UNLOADING LOCATION', textAlign: TextAlign.center,)]
                          )
                        )
                      ),
                      DataColumn(
                              label: Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text('DATE DELIVERED', textAlign: TextAlign.center)]
                                )
                              )
                            ),
                      DataColumn(
                        label: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('TIME', textAlign: TextAlign.center)]
                          )
                        )
                      ),
                    ],
                    rows: _rows ?? [], // Populate rows with data
                  ),
                ],
              )
            
          ),
        ),
      ),
    );
  }
}