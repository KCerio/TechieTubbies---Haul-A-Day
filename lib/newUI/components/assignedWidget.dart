import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:haul_a_day_web/newUI/components/assignDialog.dart';

class AssignedWidget extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;
  const AssignedWidget({Key? key, required this.orderDetails}) : super(key: key);

  @override
  State<AssignedWidget> createState() => _AssignedWidgetState();
}

class _AssignedWidgetState extends State<AssignedWidget> {
  List<Map<String, dynamic>> toBeAssigned = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(Map<String, dynamic> order in widget.orderDetails){
      if(order['assignedStatus'] == 'false' && order['confirmed_status'] == true){
        toBeAssigned.add(order);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: toBeAssigned.length,
      options: CarouselOptions(
        scrollDirection: Axis.horizontal,
        //aspectRatio: 16/9,
        viewportFraction: 0.3 ,// Adjust this value to change the number of items seen in every page
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: false,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          // Your callback
        },
        scrollPhysics: BouncingScrollPhysics(),
       // itemMargin: 10.0, // Adjust this value to change the distance between widgets
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return assignContainer(toBeAssigned[index]);
      },
    );
  }

  Widget assignContainer(Map<String,dynamic> order) {
    return InkWell(
      onTap: () {
        if(order['assignedStatus'] == 'true' && order['confirmed_status'] == true){
          null;
        } else if(order['assignedStatus'] == 'false' && order['confirmed_status'] == true){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                content: AssignDialog(order: order,),
              );
            },
          );
        } else if(order['assignedStatus'] == 'false' && order['confirmed_status'] == false){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error"),
                content: const Text("Order Not Confirmed!"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
        height: 215,
        width:230,
        decoration: BoxDecoration(
          color: order['assignedStatus'] == 'true'? Color.fromRGBO(58, 202, 66, 0.4): Color.fromRGBO(58, 202, 66, 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Column(
          children: [
            Text(
              '${order['id']}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),
            Container(
              width:230,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white, 
                border: Border(
                  top: BorderSide(color: Colors.black, width: 1.0,),
                  bottom: BorderSide(color: Colors.black, width: 1.0,),
                ),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Text(
                    order['cargoType'] == 'cgl' ?  'Dry'
                    : order['cargoType'] == 'fgl' ? 'Frozen' 
                    : '',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Image.asset('images/cargoTruckIcon.png',fit: BoxFit.scaleDown,)
                ],
              ),
            ),
            Container(
              width:230,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Color.fromRGBO(218, 218, 218, 1), 
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 1.0,),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${order['company_name']}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Image.asset('images/cargoBox.png',width: 25,height: 25,),
                      SizedBox(width:3),
                      Text(
                        '${order['totalCartons']} ctns',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.access_time, size: 25,),
                      SizedBox(width:3),
                      Text(
                        '${order['loadingDate']}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.normal
                        )                    
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
