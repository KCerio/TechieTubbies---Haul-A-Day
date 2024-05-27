import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/web_Pages/deliveryDashboard/reassignDialog.dart';

class ReschedDelivery extends StatefulWidget {
  final List<Map<String, dynamic>> deliveries;
  const ReschedDelivery({super.key, required this.deliveries});

  @override
  State<ReschedDelivery> createState() => _ReschedDeliveryState();
}

class _ReschedDeliveryState extends State<ReschedDelivery> {
  List<Map<String, dynamic>> haltedDeliveries = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    haltedDeliveries = widget.deliveries;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
            padding: const EdgeInsets.only(bottom: 10, top:10),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Halted Deliveries',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 26,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(width: 20,),
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,

              ),
              child: Text(
                haltedDeliveries.length.toString(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            )
          ],
        ),
        
        const Divider(color: Colors.blue,),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(16),
          height: 250, // Set a fixed height for the container
          width: double.infinity, // Make the container expand horizontally
          decoration: const BoxDecoration(color: Color.fromARGB(109, 223, 222, 222)),
          child: haltedDeliveries.length == 0 
          ? Container(
            height: 300,
            child: const Center(
              child: Text(
                'No deliveries need to be reassigned',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),  
                )
              ),
            )          
          : assignCarousel()
        ),
      ],
    );
  }

  Widget assignCarousel(){
    return CarouselSlider.builder(
      itemCount: haltedDeliveries.length,
      options: CarouselOptions(
        scrollDirection: Axis.horizontal,
        enableInfiniteScroll: false, // Set this to false
        //height: 230,
        //aspectRatio: 16/9,
        viewportFraction: 0.3 ,// Adjust this value to change the number of items seen in every page
        initialPage: 0,
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
        return deliveryContainer(haltedDeliveries[index]);
      },
    );
  }

  Widget deliveryContainer(Map<String, dynamic> delivery){
   
    return InkWell(
      onTap: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return UpdateSchedule(delivery: delivery);
          },
        );

      },
      child: Container(
        padding: EdgeInsets.all(12),
        width: 200,
        height: 220,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 87, 189, 90),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
        ),
        child: Column(
          children: [
            // Text(
            //   delivery['id'],
            //   style: TextStyle(
            //     fontFamily: 'Inter',
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold
            //   ),
            // ),
            Container(
              width:200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white, 
                border: Border(
                  top: BorderSide(color: Colors.black, width: 1.0,),
                  bottom: BorderSide(color: Colors.black, width: 1.0,),
                ),
              ),
              child: Image.asset('images/cargoTruckIcon.png',fit: BoxFit.scaleDown,)
            ),
            const SizedBox(height: 10),
            Text(
              '${delivery['id']} - ${delivery['route']}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Text(
            //   registeredDate,
            //   style: TextStyle(
            //     fontFamily: 'Inter',
            //     fontSize: 14,
                
            //   ),
            // ),
          ],
        )
      ),
    );
  }
}