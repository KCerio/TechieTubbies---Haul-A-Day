import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/web_Pages/customerPage/createOrder.dart';
import 'package:flutter/services.dart';


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
                  color: Colors.green[700],
                ),
                tabs: [
                  Tab(text: '   ABOUT   '),
                  Tab(text: '   DELIVERY   '),
                  Tab(text: '   CONTACT   '),
                  Tab(text: '   MANAGEMENT   '),
                ],
                labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
                labelStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.green[700],
                onTap: (index) {
                  if (index == 3) {
                    // If the "MANAGEMENT" tab is clicked, navigate to the login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login_screen()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          homePage(),
          DeliveryHomePage(tabController: _tabController),
          contactPage(),
          Container(),
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
      child: Container(
        child: SingleChildScrollView(
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
              const SizedBox(height:20),
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
              const SizedBox(height: 30,),
          
              TextButton(onPressed: (){
                _tabController.animateTo(1);
              },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green[700]!),
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
        ),
      ),
      // Placeholder content
    );
  }

  Widget contactPage(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/contactpageBackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get in touch',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 64
                    ),
                  ),
                  Text(
                    'with CUC Cargo Services',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 52
                    ),
                  ),
                  SizedBox(height: 40,),
            
                  Container(
                    width: 800,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.phone,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            'TELEPHONE',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 24
                            ),
                          ),
                        ],),
                        Container(
                          padding: EdgeInsets.only(left: 50),
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: '032-888-6915'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Copied to clipboard!',
                                    style: TextStyle(color: Colors.green, fontSize: 14),
                                  ),
                                  backgroundColor: Color.fromRGBO(230, 227, 227, 0.886),
                                ),
                              );
                            },
                            child: Text(
                              '032-888-6915',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontSize: 24,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.green                         
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:20),
            
                        Row(children: [
                          Icon(Icons.email,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            'EMAIL',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 24
                            ),
                          ),
                        ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 50),
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: 'cuccargoservices@yahoo.com'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Copied to clipboard!',
                                    style: TextStyle(color: Colors.green, fontSize: 14),
                                  ),
                                  backgroundColor: Color.fromRGBO(230, 227, 227, 0.886),
                                ),
                              );
                            },
                            child: Text(
                              'cuccargoservices@yahoo.com',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontSize: 24,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.green                         
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 50),
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: 'cuccargoservices@gmail.com'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Copied to clipboard!',
                                    style: TextStyle(color: Colors.green, fontSize: 14),
                                  ),
                                  backgroundColor: Color.fromRGBO(230, 227, 227, 0.886),
                                ),
                              );
                            },
                            child: Text(
                              'cuccargoservices@gmail.com',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontSize: 24,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.green                         
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height:20),
            
                        Row(children: [
                          Icon(Icons.pin_drop,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            'ADDRESS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 24
                            ),
                          ),
                        ],),
                        Container(
                          padding: EdgeInsets.only(left: 50),
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: '450 Peace Valley Homes, Bulacao, Cebu City, Cebu, Philippines'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Copied to clipboard!',
                                    style: TextStyle(color: Colors.green, fontSize: 14),
                                  ),
                                  backgroundColor: Color.fromRGBO(230, 227, 227, 0.886),
                                ),
                              );
                            },
                            child: Text(
                              '450 Peace Valley Homes, Bulacao,\n'
                              'Cebu City, Cebu, Philippines',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontSize: 24,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.green                         
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
