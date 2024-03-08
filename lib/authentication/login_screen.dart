import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String adminusername = "";
  String adminpassword = "";
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.height > 770 ? 64 : size.height > 670 ? 32 : 16),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: size.height * (size.height > 770 ? 0.7 : size.height > 670 ? 0.8 : 0.9),
            width: 500,
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset("images/logo1.png"),
                      ),

                      Text(
                        "Login to Haul-a-day",
                        style: TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold 
                        ),
                      ),

                      Text(
                        "Login using your Haul-a-day account",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 0, 0, 0),
                          //fontWeight: FontWeight.bold 
                        ),
                      ),

                      SizedBox(
                        height: 32,
                      ),

                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          suffixIcon: Icon(
                            Icons.mail_outline,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 32,
                      ),

                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          suffixIcon: Icon(
                            Icons.lock_outline,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 64,
                      ),

                      //actionButton("Log In"),

                      SizedBox(
                        height: 32,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            "You do not have an account?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),

                          SizedBox(
                            width: 8,
                          ),

                          GestureDetector(
                            onTap: () {
                              //widget.onSignUpSelected();
                            },
                            child: Row(
                              children: [

                                Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(
                                  width: 8,
                                ),

                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.amber,
                                ),
                                
                              ],
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
      )
      )
    )
    );
        
    }}