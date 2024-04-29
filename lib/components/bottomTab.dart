import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../accountTab/account_tab.dart';
import '../deliveryTab/delivery_tab.dart';
import '../truckTeamTab/truckteam_tab.dart';

class BottomTab extends StatefulWidget {

  final int currIndex; // Define currentIndex as a parameter

  const BottomTab({
    Key? key,
    required this.currIndex,
  }) : super(key: key);
  @override
  _BottomTabState createState() => _BottomTabState();

}

class _BottomTabState extends State<BottomTab> {



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomNavigationBar(
          currentIndex: widget.currIndex,
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.green[200],
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.truck),
              label: 'Truck Team',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_rounded),
              label: 'Delivery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TruckTeam()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountTab()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeliveryTab()),
              );
            }
          },
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 3 * widget.currIndex,
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 3,
            color: Colors.green[700],
          ),
        ),
      ],
    );
  }
}