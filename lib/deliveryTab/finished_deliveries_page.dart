import 'package:flutter/material.dart';
import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';

import '../bottomTab.dart';

class WellDonePage extends StatefulWidget {
  final int totalDelivered;
  final String orderId;

  WellDonePage({required this.totalDelivered, required this.orderId});

  @override
  State<WellDonePage> createState() => _WellDonePageState();
}

class _WellDonePageState extends State<WellDonePage> {
  int _currentIndex = 1;
 // This variable should be in a StatefulWidget if you want to use setState
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        automaticallyImplyLeading: false,
        title: Text(
          'Well Done!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliveryTab()), // Make sure to import DeliveryTab
            ); // This will pop the current route and go back
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.thumb_up,
              size: 200,
              color: Color(0xff3871C1),
            ),
            SizedBox(height: 20),
            Text(
              "you've completed",
              style: TextStyle(fontSize: 34),
            ),
            Text(
              '${widget.totalDelivered}',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
            Text(
              "deliveries of",
              style: TextStyle(fontSize: 34),
            ),
            Text(
              '${widget.orderId}',
              style: TextStyle(fontSize: 42, color: Color(0xff3871C1),fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    );
  }
}
