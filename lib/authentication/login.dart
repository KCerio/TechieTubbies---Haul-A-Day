import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/controllers/menuController.dart';
import 'package:haul_a_day_web/homepage/homepage.dart';
//import 'package:haul_a_day_web/page/menupage2.dart';
import 'package:haul_a_day_web/newUI/homescreen.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final Function onSignUpSelected;
  const Login({required this.onSignUpSelected});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formfield = GlobalKey<FormState>();
  String adminusername = "";
  String adminpassword = "";
  var _isObscured = true;
  var usernameCheck;
  //var passwordCheck;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _db = FirebaseFirestore.instance;


  void disposer(){
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void onSignUpSelected() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  void _login() async {
    if (_formfield.currentState!.validate()) {
      // Validation successful, perform login action
      _checkIfUser(adminusername, adminpassword);
    }
  }

  _checkIfUser(String username, String password) async {
    DatabaseService databaseService = DatabaseService();

    // Declare progressContext outside the showDialog function
        BuildContext? progressContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Update progressContext inside the showDialog function
        progressContext = context;
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.green,),
                SizedBox(height: 20),
                Text('Loging in...'),
              ],
            ),
          ),
        );
      },
    );
    
    QuerySnapshot usernameQuerySnapshot = await _db
    .collection('Users')
    .where('userName', isEqualTo: username)
    .where('password', isEqualTo: password)
    .get();

    QuerySnapshot staffIdQuerySnapshot = await _db
      .collection('Users')
      .where(FieldPath.documentId, isEqualTo: username)
      .where('password', isEqualTo: password)
      .get();

    
    if(usernameQuerySnapshot.docs.isNotEmpty){
        // Get the first document in the query snapshot
      QueryDocumentSnapshot user = usernameQuerySnapshot.docs.first;
      
      // Access the document ID
      String userId = user.id;

      Map<String, dynamic> userInfo = await databaseService.fetchUserDetails(userId);
        if (progressContext != null) {
          Navigator.pop(progressContext!);
        }
        if(userInfo['accessKey'] == null){
          showDialog(context: context, builder: 
          (_) => AlertDialog(title: Text("Error"), content: Text("Your Account needs to be approved!"),));
        }else if(userInfo['accessKey'] == 'Basic'){
          showDialog(context: context, builder: 
          (_) => AlertDialog(title: Text("Error"), content: Text("You are not authorized to access this site!"),));
        }
        else{
          Navigator.push( 
          context, 
          MaterialPageRoute( 
              builder: (context) => 
                  homepage(context, userInfo))); 
        }

    }else if(staffIdQuerySnapshot.docs.isNotEmpty){
      QueryDocumentSnapshot user = staffIdQuerySnapshot.docs.first;
      
      // Access the document ID
      String userId = user.id;
      Map<String, dynamic> userInfo = await databaseService.fetchUserDetails(userId);
        if (progressContext != null) {
          Navigator.pop(progressContext!);
        }

        if(userInfo['accessKey'] == null){
          showDialog(context: context, builder: 
          (_) => AlertDialog(title: Text("Error"), content: Text("Your Account needs to be approved!"),));
        }else if(userInfo['accessKey'] == 'Basic'){
          showDialog(context: context, builder: 
          (_) => AlertDialog(title: Text("Error"), content: Text("You are not authorized to access this site!"),));
        }
        else{
          Navigator.push( 
          context, 
          MaterialPageRoute( 
              builder: (context) => 
                  homepage(context, userInfo))); 
        }

    }
    else{
      if (progressContext != null) {
          Navigator.pop(progressContext!);
        }
      showDialog(context: context, builder: 
      (_) => AlertDialog(title: Text("Error"), content: Text("Invalid credentials entered. Please Try Again!"),));
    }
  }
 
 Widget homepage(BuildContext context, Map<String, dynamic> userInfo) {
    return MaterialApp(
      title: 'Haul-A-Day Website',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: Homepage(userInfo: userInfo,),
      ),
    );
  } 

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Padding(
      padding: EdgeInsets.all(size.height > 770 ? 64 : size.height > 670 ? 32 : 16),
      child: Center(
        child: Card(
          elevation: 4,
          shape: const RoundedRectangleBorder(
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
                  child: Form(
                    key: _formfield,
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("images/logo1.png"),
                        const Text(
                          "Login to Haul-a-day",
                          style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold 
                          ),
                        ),
                        const Text(
                          "Login using your Haul-a-day account",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 0, 0, 0),
                            //fontWeight: FontWeight.bold 
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          onFieldSubmitted: (_) {
                            _login();
                          },
                          controller: usernameController,
                          validator: (value){
                            adminusername = usernameController.text.trim();
                            if(value!.isEmpty){
                              return "Enter Username or Staff ID";
                            }
                            else if(usernameCheck == false){
                              return "The username or staff ID you entered cannot be found";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Username or Staff ID',
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          onFieldSubmitted: (_) {
                            _login();
                          },
                          controller: passwordController,
                          obscureText: _isObscured,
                          validator: (value){
                            adminpassword =  passwordController.text.trim();
                            if(value!.isEmpty){
                              return "Enter Password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
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
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _login,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 102, 179, 101)),
                            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
                          ), 
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              color: Colors.white, 
                              letterSpacing: 2, 
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "You do not have an account?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                widget.onSignUpSelected();
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //const SizedBox(height:5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Or are you a customer?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push( 
                                context, 
                                MaterialPageRoute( 
                                    builder: (context) => 
                                        CustomerHomePage())); 
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    "Customer",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
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
            ),
      )
      )
    )
    );

    

    }}