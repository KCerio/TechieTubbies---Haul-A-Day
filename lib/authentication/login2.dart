import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Option selectedOption = Option.Login;

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
                  child: Container(child: LoginScreen(),) 
                )
              ],
            )
          ],
        ),
      )
    );
  }
}