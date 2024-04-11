import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/authentication/login.dart';
import 'package:haul_a_day_web/authentication/signup.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  Option selectedOption = Option.Login;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    print(size.height);
    print(size.width);

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: size.width*0.5,
                  color: Colors.white,
                  child: FittedBox(
                    child: Image.asset("images/truck.png"),
                  fit: BoxFit.fill,
                  )
                ),
                Container(
                  height: double.infinity,
                  width: size.width/2,
                  color: Color.fromARGB(255, 102, 179, 101),
                  child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),

              //Animation 2
              transitionBuilder: (widget, animation) => ScaleTransition(
                child: widget, 
                scale: animation
              ),

              child: selectedOption == Option.Login
              ? Login(
                onSignUpSelected: (){
                  setState(() {
                    selectedOption = Option.SignUp;
                  });
                }
              )
              : SignUp(
                onLogInSelected: () {
                  setState(() {
                    selectedOption = Option.Login;
                  });
                },
              ),
            ),
                
                ),
                
              ],
            ),
            
          ],
        ),
      )
    );
  }
}