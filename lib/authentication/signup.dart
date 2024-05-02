import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_web/models/user_model.dart';
import 'package:haul_a_day_web/repository/user_repository.dart';

class SignUp extends StatefulWidget {
  final Function onLogInSelected;
  const SignUp({super.key, required this.onLogInSelected});
  
  @override
  State<SignUp> createState() => _SignUpState();
}


class _SignUpState extends State<SignUp> {
  // text controllers for the textfields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController staffIdController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  
  String adminpassword = "";
  String username ="";
  final _formfield = GlobalKey<FormState>();

  var _isObscured1 = true;
  var _isObscured2 = true;
  //final myController = TextEditingController();

  final userRepo = Get.put(UserRepository());
  final _db = FirebaseFirestore.instance;


  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    staffIdController.dispose();
    usernameController.dispose();
    super.dispose();
  }
  void onLoginSelected() {
  Navigator.pushReplacementNamed(context, '/login');
}

  void _signUp()async{
    if(_formfield.currentState!.validate()){
      String confirmpass = confirmController.text.trim();
      adminpassword =  passwordController.text.trim();

      //check if confirmed password and password match
      if (confirmpass == adminpassword){

        // create user model from the filled text form fields
        final user = UserModel(
          staffId: staffIdController.text.trim(), 
          //depart_id: depart_id, 
          firstname: firstNameController.text.trim(), 
          lastname: lastNameController.text.trim(), 
          //contact_no: contact_no, 
          userName: usernameController.text.trim(), 
          password: passwordController.text.trim()
        );
      
        // check if user (staff id) already exist in database
        QuerySnapshot _staffIdQuerySnapshot = await _db.collection('Users').where('staffId', isEqualTo: staffIdController.text.trim()).get();
        if(_staffIdQuerySnapshot.docs.isNotEmpty){
          showDialog(context: context, builder: 
            (_) => const AlertDialog(title: Text("Error"), 
                content: Text("Account already exist."),));
        }else{
          // save new account to the database
          createUser(user); 
          showDialog(context: context, builder: 
            (_) => const AlertDialog(title: Text("Success"), content: Text("Account Added!"),));
          widget.onLogInSelected();
        }
      }
      else{
        showDialog(context: context, builder: 
      (_) => const AlertDialog(title: Text("Error"), content: Text("Your password does not match"),));
      }
    }
  }
  
  void createUser(UserModel user) async{
    await userRepo.createUser(user);
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
            duration: const Duration(milliseconds: 200),
            height: size.height * (size.height > 970 ? 0.7 : size.height > 670 ? 0.8 : 0.9),
            width: 500,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Form(
                    key: _formfield,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/logo1.png"),

                      const Text(
                        "Fill in your details below",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 0, 0, 0),
                          //fontWeight: FontWeight.bold 
                        ),
                      ),

                      const SizedBox(
                        height: 52,
                      ),

                      // firstname and lastname text fields
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onFieldSubmitted: (_) {
                               _signUp();
                              },
                              validator: (value){
                              if(value!.isEmpty){
                                return "Enter First Name";
                              }else{
                                bool  isValidName = RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
                                if(!isValidName){
                                  return "Invalid first name. It should not\ninclude numbers and symbols";
                                }
                              }
                              return null;
                              },
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                //suffixIcon: Icon(Icons.check),
                              ),
                            ),
                          ),
                      const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: TextFormField(
                              onFieldSubmitted: (_) {
                               _signUp();
                              },
                              validator: (value){
                              if(value!.isEmpty){
                                return "Enter Last Name";
                              }else{
                                bool  isValidName = RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
                                if(!isValidName){
                                  return '''Invalid last name. It should not\ninclude numbers and symbols''';
                                }
                              }
                              return null;
                              },
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                //suffixIcon: Icon(Icons.check),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),


                      //text field for Staff Id
                      TextFormField(
                        onFieldSubmitted: (_) {
                         _signUp();
                        },
                         validator: (value){
                              if(value!.isEmpty){
                                return "Enter your Staff ID";
                              }else{
                                bool  isValidStaffId = RegExp(r'^CUC-\d{3}$').hasMatch(value);
                                if(!isValidStaffId){
                                  return "Invalid Staff ID.";
                                }
                              }
                              return null;
                          },
                        controller: staffIdController,
                        decoration: const InputDecoration(
                          //hintText: 'Staff ID',
                          labelText: 'Staff ID#',
                          //suffixIcon: Icon(Icons.check)
                        ),
                      ),

                      const SizedBox(
                        height: 32,
                      ),

                      //text field for username
                      TextFormField(
                        onFieldSubmitted: (_) {
                         _signUp();
                        },
                        validator: (value){
                              if(value!.isEmpty){
                                return "Enter username";
                              }else{
                                bool  isValidName = RegExp(r'^[a-zA-Z0-9]+(?:[._-]?[a-zA-Z0-9]+)*$').hasMatch(value);
                                if(!isValidName){
                                  return "Invalid username";
                                }
                              }
                              return null;
                          },
                        controller: usernameController,
                        decoration: const InputDecoration(
                          //hintText: 'Username',
                          labelText: 'Username',
                          //suffixIcon: Icon(Icons.check, color: Colors.green)
                        ),
                      ),

                      const SizedBox(
                        height: 32,
                      ),


                      //textfield  for password with obscure text
                      TextFormField(
                        onFieldSubmitted: (_) {
                         _signUp();
                        },
                         validator: (value){
                              if(value!.isEmpty){
                                return "Enter password";
                              }else{
                                bool  isValidPassword = RegExp(r'^(?=.*[a-zA-Z\d])[a-zA-Z\d]{8,12}$').hasMatch(value);
                                if(!isValidPassword){
                                  return "Password should contain 8 - 12 characters.";
                                }
                              }
                              return null;
                          },
                        controller: passwordController,
                        obscureText: _isObscured1,
                        decoration: InputDecoration(
                          //hintText: 'Password',
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                _isObscured1 = !_isObscured1;
                              });
                            }, 
                            child: _isObscured1 ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), 
                          )
                        ),
                      ),

                      const SizedBox(
                        height: 32,
                      ),


                      //textfield for confirmation password
                      TextFormField(
                        onFieldSubmitted: (_) {
                         _signUp();
                        },
                         validator: (value){
                              if(value!.isEmpty){
                                return "Enter password again to confirm your password";
                              }else{
                                bool  isValidPassword = RegExp(r'^(?=.*[a-zA-Z\d])[a-zA-Z\d]{8,12}$').hasMatch(value);
                                if(!isValidPassword){
                                  return "Password should contain 8 - 12 characters.";
                                }
                              }
                              return null;
                        },
                        controller: confirmController,
                        obscureText: _isObscured2,
                        decoration: InputDecoration(
                          //hintText: 'Confirm Password',
                          labelText: 'Confirm Password',
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                _isObscured2 = !_isObscured2;
                              });
                            }, 
                            child: _isObscured2 ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), 
                          )
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      

                      // if user has an account, switch to login widget
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          GestureDetector(
                            onTap: () {
                              widget.onLogInSelected(); //login widget
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "Log In",
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


                    // Sign up button                 
                    ElevatedButton(
                            onPressed: () async {
                              
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 102, 179, 101)),
                              foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
                            ), 
                            child: const Text("Sign up",
                            style: TextStyle(
                              color: Colors.white, 
                              letterSpacing:2, 
                              fontSize: 20,
                              fontWeight: FontWeight.bold),  
                            )
                        )
                       
                    ],
                  ),
                  )
                ),
              ),
            ),
      )
      )
    )
    );

    

    }}