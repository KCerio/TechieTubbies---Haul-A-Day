import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/web_Pages/orderDashboard/assignDialog.dart';
import 'package:intl/intl.dart';

class UpdateSchedule extends StatefulWidget {
  final Map<String, dynamic> delivery;
  final Function(bool?) resolved;
  const UpdateSchedule({super.key, required this.delivery, required this.resolved});

  @override
  State<UpdateSchedule> createState() => _UpdateScheduleState();
}

class _UpdateScheduleState extends State<UpdateSchedule> {
  bool? reassign;
  DatabaseService databaseService = DatabaseService();
  
  @override
  Widget build(BuildContext context) {
    String issuedDate = DateFormat('MMM dd, yyyy').format(widget.delivery['TimeDate'].toDate());
    String issuedTime = DateFormat('HH:mm a').format(widget.delivery['TimeDate'].toDate());
    String todayDate = DateFormat('MMM dd, yyyy').format(DateTime.now());
    String todayTime = DateFormat('HH:mm a').format(DateTime.now());

    return Center(
      child: Container(
        height: 800,
        width: 900,
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back, size: 25),
                  ),
                  const SizedBox(width: 80),
                  const Text('Reassign Schedule',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
          contentPadding: EdgeInsets.all(20),
          content: Container(
            height: 400,
            width: 850,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.zero,
                  bottom: Radius.circular(10.0),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              'Date and Time Issued',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue),
                                    ),
                                    child: Text(issuedDate),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue),
                                    ),
                                    child: Text(issuedTime),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      'Location',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blue),
                                        ),
                                        child: Text(widget.delivery['location']),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      'Reason/s for unsucessful delivery',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blue),
                                        ),
                                        child: Text(
                                          '${widget.delivery['reason']}: ${widget.delivery['reasonSpecified']}',
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              'Date and Time Received',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blue),
                                        ),
                                        child: Text(todayDate),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blue),
                                        ),
                                        child: Text(todayTime),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      'Assign Crew and Truck',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue),
                                    ),
                                    child: Text(widget.delivery['assignedTruck']),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    width: 200,
                                    child: ElevatedButton(
                                      onPressed: ()async{
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirmation'),
                                              content:  Text('Do you wish to resolve the problem and continue the delivery?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {         
                                                    databaseService.resolve(widget.delivery['id']);                                           
                                                    setState(() {   
                                                      widget.delivery['isHalted'] = false;                                       
                                                      widget.delivery['isResolved'] = true;                                          
                                                    });
                                                    Navigator.pop(context);                                            
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);                                            
                                                  },
                                                  child: const Text('No'),
                                                ),
                                              ],
                                            );
                                          },
                                        );                                          
                                        
                                      }, 
                                      child: Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.white,),
                                          SizedBox(width: 5,),
                                          Text('Resolved', style: TextStyle(color: Colors.white))
                                        ],
                                      ),
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                                        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(98, 123, 247, 1)),
                                        //foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    width: 200,
                                    child: ElevatedButton(
                                      onPressed: ()async{
                                        bool deleteprevTeam = await databaseService.changeTruckTeam(widget.delivery['id']);
                                        String? assigned = await showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                contentPadding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                ),
                                                content: AssignDialog(order: widget.delivery, onAssigned: (value) {
                                                  Navigator.of(context).pop(value); // Close the dialog and return the assigned value
                                                },),
                                              );
                                            },
                                          );
                                          print('AssignS: $assigned');
                                          // Now that the dialog has finished, get the assigned truck ID
                                          if (assigned != null && assigned.isNotEmpty) {
                                            DateTime timestamp = DateTime.now();
                                            String timestampString = timestamp.toIso8601String(); // Convert DateTime to string
                                            
                                            databaseService.resolve(widget.delivery['id']);

                                            setState(() {
                                              reassign = true;
                                              widget.delivery['isResolved'] = true;
                                              widget.delivery['isHalted'] = false;
                                              widget.delivery['assignedTruck'] = assigned;
                                              widget.delivery['assignedStatus'] = 'true';
                                              widget.delivery['assignedTimestamp'] = timestampString; // Add timestamp as a string to the map
                                            });
                                            print(widget.delivery['assignedStatus']);
                                          }
                                        
                                      }, 
                                      child: Row(
                                        children: [
                                          Icon(Icons.local_shipping_rounded, color: Colors.white,),
                                          SizedBox(width: 5,),
                                          Text('Reassign', style: TextStyle(color: Colors.white))
                                        ],
                                      ),
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                                        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(98, 123, 247, 1)),
                                        //foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.center,
                          //         children: [
                          //           Checkbox(
                          //             value: false,
                          //             onChanged: (bool? value) {
                          //               // Handle checkbox change
                          //             },
                          //           ),
                          //           const SizedBox(width: 10),
                          //           const Text(
                          //             'Confirm Schedule',
                          //             style: TextStyle(
                          //                 fontWeight:
                          //                     FontWeight.normal),
                          //           ),
                          //         ]),
                          //   ],
                          // ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                onPressed: () {
                                  print(widget.delivery['isResolved']);
                                  //Navigator.of(context).pop();
                                  if(widget.delivery['isResolved'] == true){
                                    widget.resolved(true);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue
                                      .shade900, // Background color
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.horizontal(
                                      left: Radius.circular(10.0),
                                      right: Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: const Text('Save',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.all(3.0),
                                        child: Text(
                                          'Documentation',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .horizontal(
                                                      left: Radius
                                                          .circular(10),
                                                      right: Radius
                                                          .circular(10)),
                                              color:
                                                  Colors.blue.shade100,
                                              border: Border.all(
                                                  color: Colors.blue),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: widget.delivery['documentation'] != null
                                                  ? Image.network(
                                                widget.delivery['documentation'],
                                                width: 195,
                                                height: 195,
                                                fit: BoxFit.cover, // Adjust the fit as needed
                                              )
                                                  : Icon(Icons.picture_in_picture)
                                            ),
                                            //forda upload files or picture
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
