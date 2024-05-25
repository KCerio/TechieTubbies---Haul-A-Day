import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewOrder extends StatelessWidget {
  const ViewOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  title: Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // background color
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start, // aligns the icon and text to the start
                              children: [
                                Icon(Icons.arrow_back,
                                    size: 15, color: Colors.white),
                                SizedBox(
                                    width: 10), // spacing between icon and text
                                Text('Back',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Text('NEW ORDER',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(200, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text(
                                      'Order Collection',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(width: 4),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text(
                                      'Loading Collection',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(width: 4),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text(
                                      'Unloading Collection',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              height: 5.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(20),
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
                              padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(
                                              'Haul-a-Day Cargo Services',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(
                                              'Delivering excellence, one package at a time.',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(
                                              'A hassle free services that transports your',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(
                                              'goods, merchandise, or commodities from one ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(
                                              'place to another. ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                //insert here
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Center(
                                                        child: Container(
                                                          height:
                                                              double.infinity,
                                                          width:
                                                              double.infinity,
                                                          child: AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            title: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.green, // background color
                                                                      ),
                                                                      child:
                                                                          const Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start, // aligns the icon and text to the start
                                                                        children: [
                                                                          Icon(
                                                                              Icons.arrow_back,
                                                                              size: 15,
                                                                              color: Colors.white),
                                                                          SizedBox(
                                                                              width: 10), // spacing between icon and text
                                                                          Text(
                                                                              'Back',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            20),
                                                                    const Text(
                                                                        'NEW ORDER',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    const Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            200,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                                                              child: Text(
                                                                                'Order Collection',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                    const SizedBox(
                                                                        width:
                                                                            4),
                                                                    const Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            25,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                                                              child: Text(
                                                                                'Loading Collection',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                    const SizedBox(
                                                                        width:
                                                                            4),
                                                                    const Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            25,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                                                              child: Text(
                                                                                'Unloading Collection',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 10),
                                                                          ],
                                                                        )),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3),
                                                                      child:
                                                                          Container(
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                4.0),
                                                                        height:
                                                                            5.0,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            contentPadding:
                                                                const EdgeInsets.all(
                                                                    20),
                                                            content: Container(
                                                              height: 400,
                                                              width: 850,
                                                              child:
                                                                  DecoratedBox(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .vertical(
                                                                    top: Radius
                                                                        .zero,
                                                                    bottom: Radius
                                                                        .circular(
                                                                            10.0),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          20.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SingleChildScrollView(
                                                                          child:
                                                                              Container(
                                                                        height:
                                                                            500,
                                                                        width:
                                                                            250,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: const BorderRadius.horizontal(
                                                                              left: Radius.circular(15),
                                                                              right: Radius.circular(15)),
                                                                          color: Colors
                                                                              .green
                                                                              .shade100,
                                                                          border:
                                                                              Border.all(color: Colors.green.shade100),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(20),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(3.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.business, color: Colors.black), // Building icon
                                                                                    SizedBox(width: 4), // Spacing between icon and text
                                                                                    Text(
                                                                                      'Name of the Company that applied to our service',
                                                                                      style: TextStyle(
                                                                                        fontSize: 7,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 200,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.green),
                                                                                        ),
                                                                                        child: TextField(
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.grey[200],
                                                                                            hintText: '',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 2),
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(3.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.local_shipping, color: Colors.black), // Building icon
                                                                                    SizedBox(width: 4), // Spacing between icon and text
                                                                                    Text(
                                                                                      'Cargo Type',
                                                                                      style: TextStyle(
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 200,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.green),
                                                                                        ),
                                                                                        child: TextField(
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.grey[200],
                                                                                            hintText: '',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 2),
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(3.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.location_on, color: Colors.black), // Building icon
                                                                                    SizedBox(width: 4), // Spacing between icon and text
                                                                                    Text(
                                                                                      'Loading Location',
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 200,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.green),
                                                                                        ),
                                                                                        child: TextField(
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.grey[200],
                                                                                            hintText: '',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 2),
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(3.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.event, color: Colors.black), // Building icon
                                                                                    SizedBox(width: 4), // Spacing between icon and text
                                                                                    Text(
                                                                                      'Loading time and date',
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 200,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.green),
                                                                                        ),
                                                                                        child: TextField(
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.grey[200],
                                                                                            hintText: '',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 2),
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(3.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.directions, color: Colors.black), // Building icon
                                                                                    SizedBox(width: 4), // Spacing between icon and text
                                                                                    Text(
                                                                                      'Route',
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 200,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.green),
                                                                                        ),
                                                                                        child: TextField(
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.grey[200],
                                                                                            hintText: '',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 2),
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(3.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.widgets, color: Colors.black), // Building icon
                                                                                    SizedBox(width: 4), // Spacing between icon and text
                                                                                    Text(
                                                                                      'Total Cartons',
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 200,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.green),
                                                                                        ),
                                                                                        child: TextField(
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.grey[200],
                                                                                            hintText: '',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 2),
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(3.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.line_weight, color: Colors.black), // Building icon
                                                                                    SizedBox(width: 4), // Spacing between icon and text
                                                                                    Text(
                                                                                      'Total Weight',
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 200,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.green),
                                                                                        ),
                                                                                        child: TextField(
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.grey[200],
                                                                                            hintText: '',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 2),
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(3.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.account_balance, color: Colors.black), // Building icon
                                                                                    SizedBox(width: 4), // Spacing between icon and text
                                                                                    Text(
                                                                                      'Warehouse',
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 200,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.green),
                                                                                        ),
                                                                                        child: TextField(
                                                                                          decoration: InputDecoration(
                                                                                            filled: true,
                                                                                            fillColor: Colors.grey[200],
                                                                                            hintText: '',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              //insert code here
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                      //insert code here
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .red, // Background color
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.horizontal(
                                                    left: Radius.circular(10.0),
                                                    right:
                                                        Radius.circular(10.0),
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                  'VIEW LOADING COLLECTION',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 50),
                            Container(
                              height: 500,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(15),
                                    right: Radius.circular(15)),
                                color: Colors.green.shade100,
                                border:
                                    Border.all(color: Colors.green.shade100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.business,
                                              color: Colors
                                                  .black), // Building icon
                                          SizedBox(
                                              width:
                                                  4), // Spacing between icon and text
                                          Text(
                                            'Name of the Company that applied to our service',
                                            style: TextStyle(
                                              fontSize: 7,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
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
                                              height: 20,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green),
                                              ),
                                              child: const Text('Virgina Cargo'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.local_shipping,
                                              color: Colors
                                                  .black), // Building icon
                                          SizedBox(
                                              width:
                                                  4), // Spacing between icon and text
                                          Text(
                                            'Cargo Type',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
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
                                              height: 20,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green),
                                              ),
                                              child: const Text(''),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: Colors
                                                  .black), // Building icon
                                          SizedBox(
                                              width:
                                                  4), // Spacing between icon and text
                                          Text(
                                            'Loading Location',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
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
                                              height: 20,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green),
                                              ),
                                              child: const Text(''),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.event,
                                              color: Colors
                                                  .black), // Building icon
                                          SizedBox(
                                              width:
                                                  4), // Spacing between icon and text
                                          Text(
                                            'Loading time and date',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
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
                                              height: 20,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green),
                                              ),
                                              child: const Text(''),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.directions,
                                              color: Colors
                                                  .black), // Building icon
                                          SizedBox(
                                              width:
                                                  4), // Spacing between icon and text
                                          Text(
                                            'Route',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
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
                                              height: 20,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green),
                                              ),
                                              child: const Text(''),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.widgets,
                                              color: Colors
                                                  .black), // Building icon
                                          SizedBox(
                                              width:
                                                  4), // Spacing between icon and text
                                          Text(
                                            'Total Cartons',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
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
                                              height: 20,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green),
                                              ),
                                              child: const Text(''),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    //insert code here
                                  ],
                                ),
                              ),
                            )
                            //insert code here
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: null,
    );
  }
}

