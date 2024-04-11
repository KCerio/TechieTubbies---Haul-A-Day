import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/trial_pages/orderdetailtrial.dart';
import 'package:haul_a_day_web/page/orderscreen.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:intl/intl.dart';

class OrderContent extends StatefulWidget {
  const OrderContent({super.key});

  @override
  State<OrderContent> createState() => _OrderContentState();
}

String selectedFilter = 'Order ID';
class _OrderContentState extends State<OrderContent> with SingleTickerProviderStateMixin {
  int totalItems = 100; // Total number of items
  int itemsPerPage = 10; // Number of items per page
  int startIndex = 1; // Track the start index of the displayed items
  DateTime startDate = DateTime.now(); // Track the start date
  DateTime endDate = DateTime.now(); // Track the end date
  bool showSearchResults = false; // Added a boolean showSearchResults to control the visibility of the search results.
  List<DataRow> _rows = [];
  List<DataRow> _filteredRows = [];
  TextEditingController orderController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  
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
                  onPressed: null,
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
  

  void _filterData(String query) {
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

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        // For Filtering data
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
                        _filterData(orderController.text);
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

            const SizedBox(width: 10), 
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
            child:LayoutBuilder(
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
                                            rows: _filteredRows, // Populate rows with data
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
                )
              ]
            )
          )
        ]
        
    );
  }
}



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
  String?  _selectedCrew2;

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
                      if(_selectedTruck == null &&
                          _selectedCrew1 == null &&
                          _selectedCrew2 == null &&
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
                        Navigator.of(context).pop();
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