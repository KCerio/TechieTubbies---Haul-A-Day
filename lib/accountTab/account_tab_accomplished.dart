
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/bottomTab.dart';
import '../components/data/accomplished_deliveries.dart';
import '../components/dateThings.dart';


class AccomplishedDeliveries extends StatefulWidget {
  final String staffId;

  const AccomplishedDeliveries({
    Key? key,
    required this.staffId,
  }) : super(key: key);

  @override
  _AccomplishedDeliveriesState createState() => _AccomplishedDeliveriesState();
}

class _AccomplishedDeliveriesState extends State<AccomplishedDeliveries> {
  int _currentIndex = 2;

  List<AccomplishedDelivery> accomplishedList =[];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData()async{
    accomplishedList = await retrieveAccomplishedDeliveries(widget.staffId);
    setState(() {
    });

  }



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          'Accomplished Deliveries',
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
      body: Center(
        child: accomplishedList.isEmpty
            ? CircularProgressIndicator(color: Colors.white,) // Show a loading indicator while data is being fetched
            :(accomplishedList.first.orderId == "null")
              ?Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.hourglassEmpty, color: Colors.green[700],size: 100,),
                  SizedBox(height: 10,),
                  Text(
                    'No Accomplished \n Deliveries Found',
                    textAlign: TextAlign.center, // Align text to the center
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ],
              )
              :Column(
            children: [
              SizedBox(height: 20),
              Expanded(child: ListView.builder(
                itemCount: accomplishedList.length,
                itemBuilder: (context, index) {
                  AccomplishedDelivery accomplishedDelivery = accomplishedList[index];
                  return accomplishedOrderContainer(accomplishedDelivery);
                },
              ))
            ],
          ),
      ),
      bottomNavigationBar: BottomTab(currIndex: _currentIndex),
    );
  }

  Widget accomplishedOrderContainer(AccomplishedDelivery accomplishedDelivery) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Container(
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            GestureDetector(
                onTap: () {

                  setState(() {
                    accomplishedDelivery.isSelected =!accomplishedDelivery.isSelected;

                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: accomplishedDelivery.isSelected ? Colors.green[600] : Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Icon(Icons.archive_outlined,
                            color: accomplishedDelivery.isSelected? Colors.white: Colors.green,
                            size: 75),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              accomplishedDelivery.orderId,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: accomplishedDelivery.isSelected? Colors.white : Colors.green),
                            ),
                            Text(
                              intoDate(accomplishedDelivery.dateCompleted),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: accomplishedDelivery.isSelected? Colors.white : Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ),
            if(accomplishedDelivery.isSelected)
              Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                child:  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: accomplishedDelivery.deliveries.length,
                  itemBuilder: (context, index) {
                    Delivery delivery = accomplishedDelivery.deliveries[index];
                    return deliveriesContainer(delivery);
                  },
                ),
              ),)
          ],
        )

      ),



    );
  }
  

  Widget deliveriesContainer(Delivery delivery){
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical:10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical:10),
        decoration: BoxDecoration(
            color: delivery.hasDelivered?Colors.green[400]:Colors.green[200],
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          children: [
            Icon(delivery.hasDelivered
                ? Icons.check_circle_outline_outlined
                : Icons.circle_outlined,
                color: delivery.hasDelivered
                    ?Colors.white
                    :Colors.grey,
                size:30),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(delivery.deliveryId,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: delivery.hasDelivered?Colors.white:Colors.black),
                ),
                Text(intoDate(delivery.dateCompleted),
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: delivery.hasDelivered?Colors.white:Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



}