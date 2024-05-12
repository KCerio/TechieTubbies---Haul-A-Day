import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UpdateSchedule extends StatelessWidget {
  const UpdateSchedule({super.key});

  @override
  Widget build(BuildContext context) {
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
                                            child: Text('Enter the Date'),
                                          ),
                                          Container(
                                            height: 30,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blue),
                                            ),
                                            child: Text('Enter the Time'),
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
                                                child: Text('Enter the Date'),
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
                                                height: 30,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blue),
                                                ),
                                                child: Text('None'),
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
                                                child: Text('Enter the Date'),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blue),
                                                ),
                                                child: Text('Enter the Time'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
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
                                              'Assign Crew and Truck',
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
                                                child: DropdownButton<String>(
                                                  value: '',
                                                  onChanged:
                                                      (String? newValue) {
                                                    // Handle dropdown value change
                                                  },
                                                  items: <String>[''].map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black), // Set text color
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          Column(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blue),
                                                ),
                                                child: DropdownButton<String>(
                                                  value: '',
                                                  onChanged:
                                                      (String? newValue) {
                                                    // Handle dropdown value change
                                                  },
                                                  items: <String>[''].map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black), // Set text color
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          Column(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blue),
                                                ),
                                                child: DropdownButton<String>(
                                                  value: '',
                                                  onChanged:
                                                      (String? newValue) {
                                                    // Handle dropdown value change
                                                  },
                                                  items: <String>[''].map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black), // Set text color
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Checkbox(
                                              value: false,
                                              onChanged: (bool? value) {
                                                // Handle checkbox change
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              'Confirm Schedule',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ]),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
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
                                                                  .circular(3),
                                                              right: Radius
                                                                  .circular(3)),
                                                      color:
                                                          Colors.blue.shade100,
                                                      border: Border.all(
                                                          color: Colors.blue),
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
