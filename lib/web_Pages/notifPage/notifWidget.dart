import 'package:flutter/material.dart';

class NotifWidget extends StatefulWidget {
  const NotifWidget({super.key});

  @override
  State<NotifWidget> createState() => _NotifWidgetState();
}

class _NotifWidgetState extends State<NotifWidget> {
  List<Map<String, dynamic>> notifications = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 410,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // you can try to delete this
              itemCount: 8,
              itemBuilder: (context, index) {
                return notifContainer(index, notifications[index]);
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget notifContainer(int index, Map<String, dynamic> notif){
    if(notif['notif'] == 'newOrder'){
      return orderNotif();
    }
    return accomplishedNotif();
  }

  Widget accomplishedNotif(){
    return Column(
      children: [
        Container(
          width: 700,
          margin: const EdgeInsets.fromLTRB(
              100, 0, 100, 0),
          padding: const EdgeInsets.fromLTRB(
              10, 0, 0, 0),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // Icon and Text "Customer X" and "16 December 2023" in a Column
              const Row(
                children: [
                  Icon(Icons.local_shipping,
                      size: 50,
                      color: Colors
                          .white), // Icon before "Customer X"
                  SizedBox(
                      width:
                          5), // Spacer between icon and text
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'Team A',
                        style: TextStyle(
                          color: Colors
                              .white, // White text color for better visibility
                          fontSize: 35,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      Text(
                        '15 December 2023',
                        style: TextStyle(
                          color: Colors
                              .white, // White text color for better visibility
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        
              // Spacer to push the "Order" text and arrows to the right
              const Spacer(),
        
              //Text Order
              Row(
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight
                                .normal,
                        color:
                            Colors.white),
                  ),
                  GestureDetector(
                      onTap: () {
                        // Assuming the order tab index is 3
                      },
                      child: const Icon(
                        Icons
                            .keyboard_double_arrow_right_outlined,
                        size:
                            50, // Set the size of the icon
                        color: Colors
                            .white, // Set the color of the icon
                      )),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height:5)
      ],
    );
  }

  Widget orderNotif(){
    return Column(
      children: [
        Container(
          width: 700,
          margin: const EdgeInsets.fromLTRB(
              100, 0, 100, 0),
          padding: const EdgeInsets.fromLTRB(
              10, 0, 0, 0),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // Icon and Text "Customer X" and "16 December 2023" in a Column
              const Row(
                children: [
                  Icon(Icons.local_shipping,
                      size: 50,
                      color: Colors
                          .white), // Icon before "Customer X"
                  SizedBox(
                      width:
                          5), // Spacer between icon and text
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'Team A',
                        style: TextStyle(
                          color: Colors
                              .white, // White text color for better visibility
                          fontSize: 35,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      Text(
                        '15 December 2023',
                        style: TextStyle(
                          color: Colors
                              .white, // White text color for better visibility
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        
              // Spacer to push the "Order" text and arrows to the right
              const Spacer(),
        
              //Text Order
              Row(
                children: [
                  const Text(
                    'Report',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight
                                .normal,
                        color:
                            Colors.white),
                  ),
                  GestureDetector(
                      onTap: () {
                        // Assuming the order tab index is 3
                      },
                      child: const Icon(
                        Icons
                            .keyboard_double_arrow_right_outlined,
                        size:
                            50, // Set the size of the icon
                        color: Colors
                            .white, // Set the color of the icon
                      )),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height:5)
      ],
    );
  }
  
}