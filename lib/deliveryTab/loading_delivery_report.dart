import 'package:flutter/material.dart';
import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';
import '../bottomTab.dart';
import 'loading_successful_reports/loading_delivery_report_successful.dart';


class LoadingDeliveryReport extends StatefulWidget {
  final LoadingDelivery loadingDelivery;
  final String deliveryId;

  const LoadingDeliveryReport({Key? key,
    required this.loadingDelivery,
    required this.deliveryId}) : super(key: key);

  @override
  _LoadingDeliveryReportState createState() => _LoadingDeliveryReportState();
}

class _LoadingDeliveryReportState extends State<LoadingDeliveryReport> {
  int _currentIndex = 1;
  int selectedButtonIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(
          'Delivery Report',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 275, // Set the maximum width
              height: 150, // Set the maximum height
              child: Image.asset(
                'assets/images/blue_truck.png', // Replace 'image.jpg' with your image asset path
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Text(
            widget.deliveryId,
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.loadingDelivery.loadingId,
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Report Confirmation',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  // Add your onPressed logic here
                  selectedButtonIndex = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoadingDeliveryReportSuccessful(loadingDelivery: widget.loadingDelivery, orderId: widget.deliveryId,)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        // return light blue when pressed
                        return Colors.blue[200]!;
                      }
                      // return blue when not pressed
                      return selectedButtonIndex == 0
                          ? Colors.blue[700]!
                          : Colors.blue[200]!;
                    },
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)),
                ),
                child: Text(
                  'Successful',
                  style: TextStyle(color: Colors.white,fontSize: 18), // Set text color
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  // Add your onPressed logic here
                  selectedButtonIndex = 1;
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        // return light blue when pressed
                        return Colors.blue[200]!;
                      }
                      // return blue when not pressed
                      return selectedButtonIndex == 1
                          ? Colors.blue[700]!
                          : Colors.blue[200]!;
                    },
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)),
                ),
                child: Text(
                  'Unsuccessful',
                  style: TextStyle(color: Colors.white, fontSize: 18), // Set text color
                ),
              ),
              SizedBox(width: 10),
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    );
  }
}
