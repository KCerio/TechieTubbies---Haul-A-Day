import 'package:flutter/material.dart';
import 'package:haul_a_day_web/homepage/createOrder.dart';

import 'tabs.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage>  with TickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/homepageBackground.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Scaffold with AppBar and body content
        Scaffold(
          backgroundColor: Colors.transparent, // Make the scaffold transparent
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Container(
                padding: EdgeInsets.only(left: 40, right: 40, bottom: 10),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset('images/cucLogo.png',width: 600, ),
                    Spacer(),
                    Tabs(0, context),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: Container(
            padding: EdgeInsets.only(left: 40, right: 40, top: 60, bottom: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivering excellence,',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 64
                      ),
                    ),
                    Text(
                      'one cargo at a time',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 56
                      ),
                    ),
                  ],
                ),
                Text(
                  'CUC Cargo Services offers a hassle free services that \n'
                      'transports your goods, merchandise, or commodities from \n'
                      'one place to another within the islands of Visayas \n'
                      'and Mindanao',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20
                  ),
                ),

                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliveryHomePage()));
                },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[700]!),
                        minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),)
                    ),
                    child: Text(
                      'SCHEDULE A DELIVERY',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:16,
                          fontWeight: FontWeight.bold
                      ),

                    )),



              ],
            ),
          ),
        ),
      ],
    );



  }







}