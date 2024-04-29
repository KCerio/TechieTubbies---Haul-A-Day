import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:provider/provider.dart';


// Create a ChangeNotifier class to manage the selected tab
class SideMenuSelection extends ChangeNotifier {
  DatabaseService databaseService = DatabaseService();
  TabSelection _selectedTab = TabSelection.Home;
  Map<String, dynamic> _orderSelected = {};
  List<Map<String, dynamic>> _updatedOrders= [];

  TabSelection get selectedTab => _selectedTab;
  Map<String, dynamic> get orderSelected => _orderSelected;
  List<Map<String, dynamic>> get updatedOrders => _updatedOrders;

  SideMenuSelection() {
    // Initialize _updatedOrders asynchronously inside the constructor
    fetchUpdatedOrders();
  }

  Future<void> fetchUpdatedOrders() async {
    _updatedOrders = await databaseService.fetchAllOrderList();
    notifyListeners();
  }
  
  void setSelectedTab(TabSelection tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void setSelectedOrder(Map<String, dynamic> orderSelected) {
    _orderSelected = orderSelected;
    notifyListeners();
  }

  void setUpdatedOrders(List<Map<String, dynamic>> orderDetails) {
    _updatedOrders = orderDetails;
    notifyListeners();
  }   
}

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 340,
              //decoration: BoxDecoration(color: const Color.fromARGB(197, 255, 255, 255),),
              child: DrawerHeader(
                child: Image.asset('images/logo2_trans.png'),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              color: const Color.fromARGB(255, 99, 174, 235),
              height: 100,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28, // Adjust the size of the circle
                    backgroundImage:Image.network("https://firebasestorage.googleapis.com/v0/b/cuc-haul-a-day.appspot.com/o/Users%2Fuser1.jpg?alt=media&token=3b0b0535-a3e6-4d0b-83a2-58dbeae840dc").image
                  ),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User's Name",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),  
                      ), // User's Fullname
                      Text(
                        "User's email",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          //fontWeight: FontWeight.bold
                        ),
                      ), // User's Fullname
                    ],
                  ) //User Pic
                  //const Text("User's Name"), // User's Fullname
                ],
              ),
            ),
            DrawerListTile(
              title: 'Home',
              svgSrc: Icons.home,
              press: () {
                Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedTab(TabSelection.Home);
                Navigator.pop(context);
              },
            ),
            DrawerListTile(
              title: 'Staff List',
              svgSrc: Icons.groups_rounded,
              press: () {
                Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedTab(TabSelection.StaffList);
                Navigator.pop(context);
              },
            ),
            DrawerListTile(
              title: 'Truck List',
              svgSrc: Icons.local_shipping,
              press: () {
                Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedTab(TabSelection.TruckList);
                Navigator.pop(context);
              },
            ),
            DrawerListTile(
              title: 'Order Dashboard',
              svgSrc: Icons.assignment_add,
              press: () {
                Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedTab(TabSelection.Order);
                Navigator.pop(context);
              },
            ),
            DrawerListTile(
              title: 'Delivery Dashboard',
              svgSrc: Icons.fact_check,
              press: () {
                Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedTab(TabSelection.Delivery);
                Navigator.pop(context);
              },
            ),
            DrawerListTile(
              title: 'Payroll',
              svgSrc: Icons.payment,
              press: () {
                Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedTab(TabSelection.Payroll);
                Navigator.pop(context);
              },
            ),
            DrawerListTile(
              title: 'Settings',
              svgSrc: Icons.settings,
              press: () {
                Navigator.pop(context);
              },
            ),
            DrawerListTile(
              title: 'Log out',
              svgSrc: Icons.exit_to_app,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const login_screen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title; 
  final IconData svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 25,
      leading: Icon(
        svgSrc,
        color: Colors.green,//ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        size: 25,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.green),
      ),
    );
  }
}