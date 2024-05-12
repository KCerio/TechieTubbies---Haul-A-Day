
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/newUI/components/attendance.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:intl/intl.dart';
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
  List<Map<String, dynamic>> _unloadings = [];
  
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
      List<Map<String, dynamic>> unloadings = await databaseService.fetchUnloadingSchedules(orderId);
      //print("Unloadings: $unloadings");
      // Update state with _unloading
          setState(() {
            stillEmpty = allReports.isEmpty;
            _allReports = allReports;
            _unloadings = unloadings;
          });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  

  @override
  Widget build(BuildContext context) {
    //print("Reports: $_allReports, $stillEmpty");
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
                return reportContainer(context,_allReports[index], widget.order,_unloadings);
              },
            ),
          ],
        )
      ),
    );
  }
}

Widget reportContainer(BuildContext context,Map<String, dynamic> report,Map<String, dynamic> order, List<Map<String, dynamic>> unloadings){
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
                content: viewReport(report, order, dialogContext, unloadings)
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

Widget viewReport(Map<String, dynamic> report, Map<String, dynamic> order, BuildContext context,List<Map<String, dynamic>> unloadings){
  var arrivalTimeStamp = report['arrivalTimeDate'].toDate();
  var arrivalTime = DateFormat('HH:mm a').format(arrivalTimeStamp);
  var arrivalDate = DateFormat('MMM dd, yyyy').format(arrivalTimeStamp);

  var departTimestamp = report['departureTimeDate'].toDate();
  var departTime = DateFormat('HH:mm a').format(departTimestamp);
  var departDate = DateFormat('MMM dd, yyyy').format(departTimestamp);

  Map<String, dynamic> unload = {};
  if(report['id'].contains('US')){
    for(Map<String, dynamic> unloading in unloadings){
      //print('Unload: ${report['id'] == unloading['unloadId']}');
      if(report['id'] == unloading['unloadId']){
        unload = unloading;
      }
    }
  }

  //print('Unload: ${unload['unloadId']}');  
  
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
                  fontSize: 18,
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
                padding:EdgeInsets.only(right:16),
                //color: Colors.amber,
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
                      //color: Colors.green,
                      child: Row(
                        children: [
                          Expanded(
                            child: percentIndicator(report, order, unload)
                          ),
                          Expanded(
                            flex:2,
                            child:Container(
                              margin: EdgeInsets.only(left:16),
                              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                              width: 215,
                              height: 148,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color.fromRGBO(190, 216, 253, 1),
                                  width: 5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    report['id'].contains('LS') ? 'Number of Cartons Loaded:'
                                    :'Number of Cartons Unloaded:',
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 19,
                                      color: Color.fromRGBO(115, 115, 115, 1)
                                    )
                                  ),
                                  Text(
                                    report['id'].contains('LS') 
                                    ? '${report['numberCartons'].toString()} / ${order['totalCartons']}'
                                    :'${report['numberCartons'].toString()} / ${unload['quantity']}',
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 55,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(56, 113, 193, 1)
                                    )
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                      width: 414,
                      height: 74,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey,width: 1)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Reasons for Incomplete Cartons:',
                            style: TextStyle(
                              fontFamily: 'InriaSans',
                              fontSize: 15,
                              color: Color.fromRGBO(148,143,143, 1)
                            )
                          ),
                          Text(
                            report['reasonIncomplete'] == '' ? 'None'
                            : report['reasonIncomplete'],
                            style: TextStyle(
                              fontFamily: 'InriaSans',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(115,115,115, 1)
                            )
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Truck Team Present",
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
                      height: 210,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(188, 195, 235, 253)//Color.fromARGB(255, 235, 236, 235),
                      ),
                      child: AttendanceWidget(reportId: report['id'], orderId: order['id'], truck: order['assignedTruck'])
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
                            color: Color.fromARGB(188, 195, 235, 253)
                          ),
                          child: Image.network(report['signatory']),
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
                            color: Color.fromARGB(188, 195, 235, 253)
                          ),
                          child: Image.network(report['documentation']),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Recipient',
                                  style: TextStyle(
                                    fontFamily: 'InriaSans',
                                    fontSize: 15,
                                    color: Color.fromRGBO(148,143,143, 1)
                                  )
                                ),
                                Text(
                                  report['recipientName'],
                                  style: TextStyle(
                                    fontFamily: 'InriaSans',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(56, 113, 193, 1)
                                  )
                                )
                              ],
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
                          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time, color: Color.fromRGBO(56, 113, 193, 1)),
                                  const SizedBox(width:12),
                                  Text(
                                    arrivalTime,
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(115,115,115, 1)
                                    )
                                  )
                                ],
                              ),
                              Divider(color: Color.fromRGBO(206, 220, 240, 1),),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_today, color: Color.fromRGBO(56, 113, 193, 1)),
                                  const SizedBox(width:12),
                                  Text(
                                    arrivalDate,
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(115,115,115, 1)
                                    )
                                  )
                                ],
                              ),
                            ],
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
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.access_time, color: Color.fromRGBO(56, 113, 193, 1)),
                                    const SizedBox(width:12),
                                    Text(
                                      departTime,
                                      style: TextStyle(
                                        fontFamily: 'InriaSans',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(115,115,115, 1)
                                      )
                                    )
                                  ],
                                ),
                                Divider(color: Color.fromRGBO(206, 220, 240, 1),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today, color: Color.fromRGBO(56, 113, 193, 1)),
                                    const SizedBox(width:12),
                                    Text(
                                      departDate,
                                      style: TextStyle(
                                        fontFamily: 'InriaSans',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(115,115,115, 1)
                                      )
                                    )
                                  ],
                                ),
                              ],
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

Widget percentIndicator(Map<String, dynamic> report, Map<String, dynamic> order, Map<String, dynamic> unload){
  double totalCartons=500;
  if(report['id'].contains('LS')){
    totalCartons = order['totalCartons'];
  }else if(report['id'].contains('US')){
    totalCartons = unload['quantity'];
  }
  double actualCartons = report['numberCartons'];
  double percent = actualCartons/totalCartons;
  return CircularPercentIndicator(
      radius: 80,
      lineWidth: 20.0,
      percent: percent ,
      animation: true,
      center: Text(
        '${percent == percent.toInt() ? percent*100 :
          (percent*100).toStringAsFixed(2)} %',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'InriaSans',
          fontSize: 30
          ),
        ),
      backgroundColor: const Color.fromARGB(255, 135, 211, 246),
      progressColor: Colors.blue,         
      circularStrokeCap: CircularStrokeCap.round,
  );
}
