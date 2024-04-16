
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DeliveryReports extends StatefulWidget {
  final Map<String,dynamic> order;
  const DeliveryReports({super.key, required this.order});

  @override
  State<DeliveryReports> createState() => _DeliveryReportsState();
}

class _DeliveryReportsState extends State<DeliveryReports> {
  List<Map<String, dynamic>> _allReports = [];
  bool stillEmpty = false;
  String _orderId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderId = widget.order['id'];
    fetchReports(_orderId);
  }

  Future<void> fetchReports(String orderId) async {
    try {
      DatabaseService databaseService = DatabaseService();
      List<Map<String, dynamic>> allReports = await databaseService.fetchDeliveryReports(orderId);
      print("database: $allReports");
      setState(() {
        stillEmpty = allReports.isEmpty; // Check if allReports is empty
        _allReports = allReports;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Reports: $_allReports, $stillEmpty");
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_allReports.isEmpty && stillEmpty == false) // Check if _allReports is empty
            const Center(child: CircularProgressIndicator())
          else if (_allReports.isEmpty && stillEmpty == true)
            Container(
              height: 300,
              child: const Center(
                child: Text(
                  'No reports yet',
                  style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),  
                  )
                ),
            )
          else ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // you can try to delete this
              itemCount: _allReports.length,
              itemBuilder: (context, index) {
                return reportContainer(context,_allReports[index], widget.order);
              },
            ),
          ],
        )
      ),
    );
  }
}

Widget reportContainer(BuildContext context,Map<String, dynamic> report,Map<String, dynamic> order){
    //print('${order['id']}: ${order['assignedStatus'].runtimeType} ${order['confirmed_status'].runtimeType }');
    //String orderRef = order['id'].substring(2, 5);
    BuildContext dialogContext;
    return Padding(
      padding: const EdgeInsets.only(right: 16,left:10),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              dialogContext = context;
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                content: viewReport(report, order, dialogContext)
              );
            },
          );
        },
        child: Container(
          height: 60,
          decoration: const BoxDecoration(
              //color: Color.fromARGB(255, 211, 208, 208), 
              border: Border( // Adding a border
                bottom: BorderSide(color: Color.fromARGB(181, 158, 158, 158), // Border color
                width: 1.0,),// Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: const Offset(0, 2), // Offset from the avatar
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromRGBO(35 , 99, 237, 0.67),
                    child: Icon(Icons.file_open_rounded, color: Colors.white, size: 35,),
                  ),
                ),

                const SizedBox(width: 10,),
                
                Text(
                    report['id'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),  
                  ),
              ]
            )
      ),
    )
      )
    );
  
}

Widget viewReport(Map<String, dynamic> report, Map<String, dynamic> order, BuildContext context){
  return Container(
    width: 1062,
    height: 689,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 16, 30, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ${order['id']} - Loading ${order['loading_id']} - Report ${report['id']}',
                style: TextStyle(
                  fontFamily: 'InriaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.normal
                ),
              ),

              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                icon: Icon(Icons.close)
              )
            ],
          ),
        ),
        Container(
          width: 1062,
          height: 600,
          //color: Colors.blue,
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Container(
                width:1012/2,
                height: 600,
                color: Colors.amber,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Cargo Details",
                        style: TextStyle(
                          fontFamily: 'InriaSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      width:1012/2,
                      height: 182,
                      color: Colors.green,
                      //child: ,
                    ),


                  ],
                ),
              ),
              Container(
                width:1012/2,
                height: 600,
                //color: Colors.green,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Signatory",
                            style: TextStyle(
                              fontFamily: 'InriaSans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          height: 241,
                          width: 236,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Documentation",
                            style: TextStyle(
                              fontFamily: 'InriaSans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          height: 241,
                          width: 236,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 235,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color.fromRGBO(190, 216, 253, 1),
                                width: 5,
                              )
                            ),
                          ),
                          const SizedBox(height:45),
                          Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Arrival",
                            style: TextStyle(
                              fontFamily: 'InriaSans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Container(
                            width: 235,
                            height: 124,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color.fromRGBO(190, 216, 253, 1),
                                width: 5,
                              )
                            ),
                          ),
                          const SizedBox(height:35),
                          Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Departure",
                            style: TextStyle(
                              fontFamily: 'InriaSans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Container(
                            width: 235,
                            height: 124,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color.fromRGBO(190, 216, 253, 1),
                                width: 5,
                              )
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );

}

Widget percentIndicator(Map<String, dynamic> report, Map<String, dynamic> order,){
  double actualCartons = double.parse(report['numberCartons']);
  double percent = actualCartons/order['totalCartons'];
  return CircularPercentIndicator(
      radius: 100.0,
      lineWidth: 10.0,
      percent: percent ,
      animation: true,
      center: Text(
        '${percent*100}%',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          ),
        ),
      backgroundColor: Colors.lightBlue,
      progressColor: Colors.blue,         
      circularStrokeCap: CircularStrokeCap.round,
  );
}
