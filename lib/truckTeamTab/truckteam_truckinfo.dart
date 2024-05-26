import 'package:flutter/material.dart';

import '../components/bottomTab.dart';
import '../components/data/truck_info.dart';


class TruckInformationPage extends StatefulWidget {
  final TruckInfo? truck;
  final String truckId;

  const TruckInformationPage({
    Key? key,
    required this.truck, required this.truckId,
  }) : super(key: key);

      @override
      _TruckInformationPageState createState() => _TruckInformationPageState();
}

class _TruckInformationPageState extends State<TruckInformationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
        title: Text(
          'Truck Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              color: Colors.green[700],
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      height: 175,
                      width: 175,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 3.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(26.0), // Adjust for padding
                          child: Image.network(
                            widget.truck!.truckPic,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                  child: Text(
                    'Truck ID',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey, // Set the color of the bottom border
                    width: 1.0, // Set the width of the bottom border
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.truckId,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                  child: Text(
                    'Maximum Capacity',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey, // Set the color of the bottom border
                    width: 1.0, // Set the width of the bottom border
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.truck!.maxCapacity} kg',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                  child: Text(
                    'Truck Type',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey, // Set the color of the bottom border
                    width: 1.0, // Set the width of the bottom border
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.truck!.truckType,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                  child: Text(
                    'Cargo Type',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey, // Set the color of the bottom border
                    width: 1.0, // Set the width of the bottom border
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.truck!.cargoType.startsWith('f')||widget.truck!.cargoType.startsWith('F'))?'Frozen Goods':'Dry Goods',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
      bottomNavigationBar:  BottomTab(currIndex: _currentIndex),
    );
  }
}
