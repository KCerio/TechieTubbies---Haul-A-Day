import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComputeDialog extends StatefulWidget {
  const ComputeDialog({super.key});

  @override
  State<ComputeDialog> createState() => _ComputeDialogState();
}

class _ComputeDialogState extends State<ComputeDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 600,
        width: 600,
        child: AlertDialog(
          backgroundColor:
              Colors.amberAccent.shade700,
          title: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                        Icons.arrow_back),
                  ),
                  const SizedBox(width: 80),
                  const Text('Compute Pay Check'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 750,
            width: 900,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.zero,
                  bottom: Radius.circular(10.0),
                ),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.fromLTRB(
                    20, 10, 0, 0),
                child: Stack(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'Accomplished Deliveries:',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight
                                        .normal),
                          ),
                          const SizedBox(
                              height: 5.0),
                          Padding(
                            padding:
                                const EdgeInsets
                                    .all(5),
                            child: Container(
                              decoration:
                                  BoxDecoration(
                                border: Border.all(
                                    color: Colors
                                        .black),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 175,
                                    height: 35,
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .grey
                                          .shade200,
                                      borderRadius: const BorderRadius
                                          .horizontal(
                                          left: Radius
                                              .circular(
                                                  1.0),
                                          right: Radius
                                              .circular(
                                                  1.0)),
                                      border: Border.all(
                                          color: Colors
                                              .black),
                                    ),
                                    child:
                                        const Padding(
                                      padding:
                                          EdgeInsets
                                              .all(
                                                  0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                        children: [
                                          Icon(
                                              Icons
                                                  .local_shipping,
                                              size:
                                                  25),
                                          SizedBox(
                                              width:
                                                  10),
                                          Text(
                                              'Delivery ID',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 175,
                                    height: 35,
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .grey
                                          .shade200,
                                      borderRadius:
                                          const BorderRadius
                                              .horizontal(),
                                      border: Border.all(
                                          color: Colors
                                              .black),
                                    ),
                                    child:
                                        const Padding(
                                      padding:
                                          EdgeInsets
                                              .all(
                                                  0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                        children: [
                                          Icon(
                                              Icons
                                                  .local_shipping,
                                              size:
                                                  25),
                                          SizedBox(
                                              width:
                                                  10),
                                          Text(
                                              'Delivery ID',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 175,
                                    height: 35,
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .grey
                                          .shade200,
                                      borderRadius:
                                          const BorderRadius
                                              .horizontal(),
                                      border: Border.all(
                                          color: Colors
                                              .black),
                                    ),
                                    child:
                                        const Padding(
                                      padding:
                                          EdgeInsets
                                              .all(
                                                  0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                        children: [
                                          Icon(
                                              Icons
                                                  .local_shipping,
                                              size:
                                                  25),
                                          SizedBox(
                                              width:
                                                  10),
                                          Text(
                                              'Delivery ID',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding:
                                const EdgeInsets
                                    .fromLTRB(
                                    20, 0, 20, 0),
                            child: Container(
                              width:
                                  480, // Adjust the width as neded
                              height:
                                  5, // Adjust the height as needed
                              child: Table(
                                border: TableBorder
                                    .all(),
                                children: const [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'TOTAL INCOME',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'AMOUNT',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              'Medical Allowance'),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              'Rice Allowance'),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              'Mobile Allowance'),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              'Clothing Allowance'),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'TOTAL DEDUCTION',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'AMOUNT',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'TAX',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'AMOUNT',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Add more rows as needed
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .start,
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (bool?
                                      value) {
                                    // Handle checkbox change
                                  },
                                ),
                                const SizedBox(
                                    width: 10),
                                const Text(
                                  'Confirm Pay Rate',
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          150, 0, 0, 0),
                      child: Expanded(
                        child:
                            SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceEvenly,
                            children: [
                              const Text(
                                'Salary:',
                                style: TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .normal),
                              ),
                              const SizedBox(
                                  height: 10.0),
                              Column(
                                children: [
                                  const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Text(
                                          '3 Deliveries Accomplished',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                        SizedBox(
                                            height:
                                                5),
                                      ]),
                                  SizedBox(
                                      width: 80),
                                  const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Text(
                                          '1 Cebu Trip',
                                        ),
                                        SizedBox(
                                            width:
                                                15),
                                        Text(
                                            'Php 800.00')
                                      ]),
                                  SizedBox(
                                      width: 80),
                                  const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Text(
                                          '2 Out-Cebu Trip',
                                        ),
                                        SizedBox(
                                            width:
                                                10),
                                        Text(
                                            'Php 1200')
                                      ]),
                                  const SizedBox(
                                      height: 10),
                                  Column(children: [
                                    Container(
                                      width: 175,
                                      height: 35,
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .grey
                                            .shade200,
                                        borderRadius: const BorderRadius
                                            .horizontal(
                                            left: Radius.circular(
                                                1.0),
                                            right: Radius.circular(
                                                1.0)),
                                      ),
                                      child:
                                          const Padding(
                                        padding:
                                            EdgeInsets
                                                .all(0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                          children: [
                                            Text(
                                                'Php 2,000.00'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ], //children
                ),
              ),
            ),
          ),
        ),
      ),
    );                          
  }
}