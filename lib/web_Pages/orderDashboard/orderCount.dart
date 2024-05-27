import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class orderCounter extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;
  const orderCounter({super.key, required this.orderDetails});

  @override
  State<orderCounter> createState() => _orderCounterState();
}

class _orderCounterState extends State<orderCounter> {
  int totalOrder = 0, confirmedOrder = 0, assignedOrder = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalOrder = widget.orderDetails.length;
    for(Map<String, dynamic> order in widget.orderDetails){
      if(order['confirmed_status'] == true){
        confirmedOrder++;
      }
      if(order['assignedStatus'] == 'true'){
        assignedOrder++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {  
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Total Order
          countWidget(totalOrder, 'Total Orders', Color.fromRGBO(58, 202, 66, 0.7), '2:15 am| Apr 11, 2024'),
          //Confirmed Order
          countWidget(confirmedOrder, 'Confirmed Orders', Color.fromRGBO(33, 150, 243, 0.8), '3:15 am| Apr 11, 2024'),
          //Assigned Order
          countWidget(assignedOrder, 'Assigned Orders', Color.fromRGBO(255, 193, 7, 0.8), '4:15 am| Apr 11, 2024'),
          
        ],
      ),
    );
  }

  Widget countWidget (int count, String countDesc, Color color, String updatetime) {
    return Container(
      height: 140,
      width:376,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 5, // Spread radius
            blurRadius: 7, // Blur radius
            offset: Offset(0, 3), // Offset from the container
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count orders',
                    style: TextStyle(
                      fontFamily: 'InriaSans',
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    countDesc,
                    style: TextStyle(
                      fontFamily: 'InriaSans',
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
              Icon(Icons.assignment, color: Colors.white,size: 80,)
            ],
          ),
          Divider(
            color: Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SizedBox(width: 20,),
              Icon(Icons.access_time, color: Colors.white,),
              SizedBox(width:10),
              Text(
                'update: $updatetime',
                style: TextStyle(
                      fontFamily: 'InriaSans',
                      fontSize: 16,
                      color: Colors.white
                ),
              )
            ],
          )
        ],
      )
    );
  }
}