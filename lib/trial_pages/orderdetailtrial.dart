import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:intl/intl.dart';

class OrderDetailsTrial extends StatefulWidget {
  final String  orderId;
  final bool status;
  const OrderDetailsTrial({super.key, required this.orderId,required this.status});

  @override
  State<OrderDetailsTrial> createState() => _OrderDetailsTrialState();
}

//String selectedFilter = 'Order ID';
class _OrderDetailsTrialState extends State<OrderDetailsTrial> {
  DatabaseService databaseService = DatabaseService();
  Map<String, dynamic> _orderDetails = {};
  Map<String, dynamic> _loadingDetails = {};
  bool confirm = true;
  
  @override
  void initState() {
    super.initState();
    _fetchData(widget.orderId);
  }

  //get unloading details
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
  
  //update confirm status
  void updateFirestoreValue() async {
    // Get a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Update the value of a document in Firestore
      // ignore: avoid_single_cascade_in_expression_statements
      firestore..collection('Order').doc(widget.orderId).update({
        'confirmed_status': true,
      });
      print('Document successfully updated');
    } catch (error) {
      print('Error updating document: $error');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
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
                           Navigator.pushReplacementNamed(context, 'OrderContent',);
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
          Container(
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
                                                  ? null // Button is disabled if order is already confirmed
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
                                              onPressed: () {
                                                
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
                                                            ? 'To be Assign'
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
                                      Expanded(child: UnloadingSchedule(orderId: widget.orderId),),
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
        ],
      ),
    );
  }
}



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

  //get order
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
        // Now you can work with the "UnloadingSchedule" collection
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