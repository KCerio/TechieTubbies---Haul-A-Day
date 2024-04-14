
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:haul_a_day_mobile/staffIDController.dart';
import 'truckTeamTab/truckteam_tab.dart'; // Importing the SecondScreen widget

class WelcomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      return false; // Returning false will prevent the user from navigating back
    },child:GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TruckTeam()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Image.asset('assets/images/techietubbies_logo.png'),
          ),
        ),
        backgroundColor: Colors.white,
        body: WelcomeBody(),
      ),
    )
    );
  }
}

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/hauladay_logo.png'),
          Animate(
            child: Text(
              'Welcome',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).fade(duration: Duration(milliseconds: 500)).scale(delay: Duration(milliseconds: 500)),
          Animate(
            child: Text(
              'Back!',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).fade(duration: Duration(milliseconds: 500)).scale(delay: Duration(milliseconds: 1000)),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: WelcomeScreen(),
    ),
  );
}
