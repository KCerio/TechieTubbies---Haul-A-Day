import 'package:flutter/material.dart';

class DeliveryReports extends StatefulWidget {
  final Map<String,dynamic> order;
  const DeliveryReports({super.key, required this.order});

  @override
  State<DeliveryReports> createState() => _DeliveryReportsState();
}

class _DeliveryReportsState extends State<DeliveryReports> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //thy list creates the containers for all the trucks
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // you can try to delete this
              itemCount: 11,
              itemBuilder: (context, index) {
                return reportContainer(widget.order,index);
              },
            ),
          ],
        )
      ),
    );
  }
}

Widget reportContainer(Map<String, dynamic> order,  int index){
    //print('${order['id']}: ${order['assignedStatus'].runtimeType} ${order['confirmed_status'].runtimeType }');
    String orderRef = order['id'].substring(2, 5);
    return Padding(
      padding: const EdgeInsets.only(right: 16,left:10),
      child: InkWell(
        onTap: () {
          
        },
        child: Container(
          height: 60,
          decoration: const BoxDecoration(
              //color: Color.fromARGB(255, 211, 208, 208), 
              border: Border( // Adding a border
                bottom: BorderSide(color: Color.fromARGB(181, 158, 158, 158), // Border color
                width: 1.0,),// Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: const Offset(0, 2), // Offset from the avatar
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromRGBO(35 , 99, 237, 0.67),
                    child: Icon(Icons.file_open_rounded, color: Colors.white, size: 35,),
                  ),
                ),

                const SizedBox(width: 10,),
                
                Text(
                    "US-$orderRef-${index+1}",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),  
                  ),
              ]
            )
      ),
    )
      )
    );
  
}