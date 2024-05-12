import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_mobile/firebase_options.dart';
import 'package:haul_a_day_mobile/shared.dart';
import 'package:haul_a_day_mobile/staffIDController.dart';
import 'package:haul_a_day_mobile/truckTeamTab/truckteam_tab.dart';
import 'package:haul_a_day_mobile/welcome_screen.dart';

import 'create_account.dart';






Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions().currentPlatform,
  );
  //await Get.putAsync(() => StaffIdController().init()); // Initialize StaffIdController

  Get.put(StaffIdController());

  runApp(MyApp());



}

class MyApp extends StatelessWidget {
  Future<String?> _getUserLoggedInStatus() async {
    return await Shared.getStaffId();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserLoggedInStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.green,);
        } else {
          // Once the data is fetched, decide which screen to show based on login status
          String? isUserLoggedIn = snapshot.data;
          return MaterialApp(
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue), // Define cursor color here
            ),
            debugShowCheckedModeBanner: false,
            home: (isUserLoggedIn != null && isUserLoggedIn.isNotEmpty) ? TruckTeam() : LoginPage(),
          );
        }
      },
    );
  }
}



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //static const String _title = "Haul-A-Day";

  final StaffIdController staffIdController = Get.put(StaffIdController());
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String enteredUsername ="";
  String enteredPassword = "";
  final _formField = GlobalKey<FormState>();


  bool _passwordVisible = false;




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      return false; // Returning false will prevent the user from navigating back
    },
    child: Scaffold(
      backgroundColor: Colors.green[700],
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          decoration:BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Mobile_LogIn_Page.png"),
                fit: BoxFit.fill, // Adjust the image to cover the whole area
              )
          ),
          child: Center(
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(20, 400, 20, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Form(
                    key: _formField,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Log In Texts
                          Text(
                            'Log In to Haul-A-Day',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Open Sans',
                            ),
                          ),
                          SizedBox(height: 2.0),//Space
                          Text(
                            'Log In using your Haul-A-Day Credentials',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Open Sans',
                              color: Colors.blue[700],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 30.0),//space

                          //Enter Username or Employee ID
                          SizedBox(height: 80,
                            child: TextFormField(
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "Enter Username or Employee ID";
                                  }
                                  return null;
                                }
                                ,
                                controller: usernameController,
                                decoration: InputDecoration(
                                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(50.0),borderSide: BorderSide.none,),
                                  fillColor: Color.fromRGBO(230, 225, 225, 100),
                                  filled: true,
                                  hintText: "Enter Username or Employee ID",
                                  hintStyle: TextStyle(
                                    color:Colors.grey[700],
                                    fontSize: 15.0,
                                  ),
                                  prefixIcon: Icon(Icons.person, color: Color.fromRGBO(90, 90, 90, 100)),


                                )

                            ),
                          ),//username,
                          SizedBox(height: 10.0),

                          //Enter Password
                          SizedBox(
                            height: 80,
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Password";
                                  }
                                  return null;
                                },
                                obscureText: !_passwordVisible,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(50.0),borderSide: BorderSide.none,),
                                  fillColor: Color.fromRGBO(230, 225, 225, 100),
                                  filled: true,
                                  hintText: "Enter Password",
                                  hintStyle: TextStyle(
                                    color:Colors.grey[700],
                                    fontSize: 15.0,
                                  ),
                                  prefixIcon: Icon(Icons.lock, color: Color.fromRGBO(90, 90, 90, 100)),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Color.fromRGBO(90, 90, 90, 100),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                )

                            ),//password
                          ),

                          SizedBox(height: 20.0),

                          //Log In Button
                          Container(
                            width: double.infinity,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: BorderSide(color: Colors.green),
                                  ),
                                ),
                              ),
                              onPressed:  (){

                                if(_formField.currentState!.validate()){
                                  enteredUsername = usernameController.text;
                                  enteredPassword = passwordController.text;

                                  print("Username: $enteredUsername  Password:$enteredPassword");
                                  _checkCredentials();
                                }

                              },
                              child: Text(
                                'Log In ',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open Sans',
                                  color: Colors.white,

                                ),
                              ),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open Sans',
                                  color: Colors.black38,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              TextButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateAccount()));
                              },
                                  child: Text(
                                    'Create Here',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Open Sans',
                                      color: Colors.green[700],
                                    ),
                                    textAlign: TextAlign.center,
                                  ))
                            ],
                          )


                        ]

                    )
                ),

              ),
            ),
          ),



        ),),
    )
    );


  }

  Future<void> _checkCredentials() async {
    String enteredUsername = usernameController.text.trim();
    String enteredPassword = passwordController.text.trim();

    // Query Firestore collection to check if the entered username exists
    QuerySnapshot usernameQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('userName', isEqualTo: enteredUsername)
        .get();

    // Query Firestore collection to check if the entered staff ID exists
    QuerySnapshot staffIdQuerySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('staffId', isEqualTo: enteredUsername)
        .get();

    // Check if any documents match the username query
    if (usernameQuerySnapshot.docs.isNotEmpty || staffIdQuerySnapshot.docs.isNotEmpty) {
      // Check if the password matches
      bool isApproved =false;

      try {
        isApproved = usernameQuerySnapshot.docs.isNotEmpty
            ?usernameQuerySnapshot.docs.first['isApproved']
            :staffIdQuerySnapshot.docs.first['isApproved'];
      } catch (e) {
        isApproved =false;
      }

      if(isApproved){
        String actualPassword = usernameQuerySnapshot.docs.isNotEmpty
            ? usernameQuerySnapshot.docs.first['password']
            : staffIdQuerySnapshot.docs.first['password'];
        String usedStaffId;
        if(usernameQuerySnapshot.docs.isNotEmpty){
          usedStaffId = usernameQuerySnapshot.docs.isNotEmpty
              ? usernameQuerySnapshot.docs.first['staffId']
              : null;

        }else{
          usedStaffId = enteredUsername;
        }

        if (actualPassword == enteredPassword) {
          // Password matches, login successful

          //print("staffID : $usedStaffId");
          staffIdController.setStaffId(usedStaffId);
          bool isLoggedIn = true;
          try {
            await Shared.saveLoginSharedPreference(isLoggedIn);
            print("Login status saved successfully.");
          } catch (e) {
            print("Error saving login status: $e");
          }

          Navigator.push(context, MaterialPageRoute(builder: (context) =>  WelcomeScreen()));
        } else {
          // Password does not match
          _showPrompt("Incorrect Password. Please Try Again!");
        }
      }

      else{
        _notApproved();
      }


    } else {
      // Username or staff ID does not exist
      _showPrompt("The Username or Staff ID you've entered cannot be found. Please Try Again!");
    }


  }

  void _showPrompt(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData( // Customize the theme
            dialogBackgroundColor: Colors.white, // Set the background color
        ),
        child: SimpleDialog(
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child:Container(
                  width: 200,
                  height: 100,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(errorMessage,
                      textAlign: TextAlign.center, // Align text to the center
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                )
              ),
            )


          ],
        ),);
      },
    );
  }

  void _notApproved() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData( // Customize the theme
            dialogBackgroundColor: Colors.white, // Set the background color
          ),
          child: SimpleDialog(
            children: <Widget>[
              Center(
                child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child:Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Text("Account Awaiting for \nApproval",
                              textAlign: TextAlign.center, // Align text to the center
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            Image.asset("assets/images/awaiting_approval.png"), //assets/images/awaiting_approval.png
                            Text("Management is working on it",
                              textAlign: TextAlign.center, // Align text to the center
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                    )
                ),
              )


            ],
          ),);
      },
    );
  }






  }



