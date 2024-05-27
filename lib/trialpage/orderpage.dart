import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/models/order_model.dart';
import 'package:haul_a_day_web/service/database.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  
  late List<DataRow>? _rows = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  //get order
  Future<void> _fetchData() async {
    List<DataRow> rows =[];
    DatabaseService databaseService = DatabaseService();

  /**
   * orderID
   * customer - Order Collection
   * cargoType - Loading Collection
   * quantity - Loading Collection
   * weight - Unloading Collection
   * date filed - Order Collection
   * status - truckTeam Collection
   */
  await FirebaseFirestore.instance.collection('Order').get().then((snapshot) async {
    for (var orddocument in snapshot.docs) {
      var orderData = orddocument.data();
      var orderID = orddocument.id;
      var customer = orderData['company_name'];

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
                onPressed: null, // Button is disabled if status is true
                child: const Text('Assign'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  // Handle button press when status is false
                  print('Status is false, do something...');
                },
                child: const Text('Assign'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 102, 179, 101)),
                  foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
                ),
              );

        
        // Add a DataRow with the retrieved data
        rows.add(DataRow(cells: [
          DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(orderID, textAlign: TextAlign.center,)]
                )
              )
            ),
          DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(customer, textAlign: TextAlign.center)]
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
                children: [Text(quantity.toString(), textAlign: TextAlign.center)]
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
                children: [statusWidget]
                )
              )
            ),
        ],
        selected: false, // Remove the checkbox
        onSelectChanged: (_){
          // Navigator.push( 
          //   context, 
          //   MaterialPageRoute( 
          //       builder: (context) => 
          //           OrderDetailsPage(orderId: orderID,)));
        }
        ));

        setState(() {
        _rows = rows;
    });
      }
    }
  }).catchError((error) {
    print('Error: $error');
  });
}
  
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Data Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3
            ), 
            itemBuilder: (context, item){

            }
          )
      ),
    );
  }

  Widget orderItem(Map<String, dynamic> order){
    return InkWell(
      onTap: () {
        
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: 50,
          height: 50,
          color: Colors.amber,
        ),
        )
    );
  }
}