import 'package:flutter/material.dart';
import 'tabs.dart';


class DeliveryHomePage extends StatefulWidget {
  @override
  _DeliveryHomePageState createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage>  with TickerProviderStateMixin {
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
              image: AssetImage('images/orderBackground.png'),
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
                    Tabs(1, context),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 60,
                vertical: 60
              ),
              child: Column(
                children: [
                  orderForm(25, context),
                  //INSERT HERE
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }



}