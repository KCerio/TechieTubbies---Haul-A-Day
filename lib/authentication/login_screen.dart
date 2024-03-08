import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String adminusername = "";
  String adminpassword = "";
  var _isObscured = true;
  var _isUser = false;
  final myController = TextEditingController();

  void disposer(){
    myController.dispose();
    super.dispose();
  }

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

                      TextFormField(
                        controller: myController,
                        decoration: InputDecoration(
                          //hintText: 'Username or Staff ID',
                          labelText: 'Username or Staff ID',
                          suffixIcon: Icon(Icons.check)
                        ),
                      ),

                      SizedBox(
                        height: 32,
                      ),

                      TextField(
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          //hintText: 'Password',
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            }, 
                            child: _isObscured ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), 
                          )
                        ),
                      ),

                      SizedBox(
                        height: 64,
                      ),

                      //actionButton("Log In"),

                      SizedBox(
                        height: 30,
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

                    SizedBox(
                        width: 8,
                    ),
                    ElevatedButton(
                            onPressed: (){

                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 102, 179, 101)),
                              foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
                            ), 
                            child: const Text("Log in",
                            style: TextStyle(
                              color: Colors.white, 
                              letterSpacing:2, 
                              fontSize: 20,
                              fontWeight: FontWeight.bold),  
                            ))

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