import 'package:flutter/material.dart';
import 'package:haul_a_day_web/homepage/createOrder.dart';
import 'tabs.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'images/cucLogo.png',
              width: 600,
            ),
            SizedBox(width: MediaQuery. of(context). size. width*(0.1)),
            Expanded(
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[700],
                ),
                tabs: [
                  Tab(text: '   ABOUT   '),
                  Tab(text: '   DELIVERY   '),
                  Tab(text: '   CONTACT   '),
                  Tab(text: '   MANAGEMENT   '),
                ],
                labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          homePage(),
          DeliveryHomePage(),
          Center(
            child: Text('PAGE ONE'),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/homepageBackground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(child: Text('MANAGEMENT')), // Placeholder content
          ),
        ],
      ),
    );
  }
  Widget homePage(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(left: 40, right: 40, top: 60, bottom: 200),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/homepageBackground.png'),
          fit: BoxFit.cover,
        ),
      ),
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
            _tabController.animateTo(1);
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
        ],),
      // Placeholder content
    );
  }
}
