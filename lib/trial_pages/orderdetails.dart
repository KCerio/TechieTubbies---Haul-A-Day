import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

//Whole Order Detail Page
class OrderDetailsPage extends StatefulWidget {
  final String  orderId;
  const OrderDetailsPage({required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  //final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(size.height > 770 ? 64 : size.height > 670 ? 32 : 16),
              child: Card(
                elevation: 4,
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      Container(
                        height: size.height / 2,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Container(
                        height: size.height / 2,
                        width: double.infinity,
                        color: Color.fromARGB(255, 140, 158, 143),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Unloading Details",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Expanded(child: UnloadingSchedule(orderId: widget.orderId),),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//Top Section of Order Detail (Loading Details)
class LoadingSchedule extends StatefulWidget {
  const LoadingSchedule({super.key});

  @override
  State<LoadingSchedule> createState() => _LoadingScheduleState();
}

class _LoadingScheduleState extends State<LoadingSchedule> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


//Bottom Section of Order Detail (Unloading Details)
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
    return  SingleChildScrollView(
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
      
    );
  }
}