import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:haul_a_day_mobile/components/data/user_information.dart';
import 'package:haul_a_day_mobile/components/dateThings.dart';
import 'package:haul_a_day_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Import 'package:flutter/services.dart' for TextInputFormatter

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String _selectedRole = ''; // Default selected role
  bool _obscureText = true; // Initially obscure the text for the password
  bool _obscureTextConfirm = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController staffId = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController contactNumber = TextEditingController();



  //form field
  final _formField = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Center(
            child: Image.asset('assets/images/white_hauladaylogo.png'),
          ),
          SizedBox(height: 10),
          Center(
            child: Image.asset('assets/images/white_hauladaytext.png'),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(50.0),
                bottom: Radius.zero, // This makes the bottom edges straight
              ),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Center(
                  child: Animate(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      .fade(
                    duration: Duration(milliseconds: 500),
                  )
                      .scale(
                    delay: Duration(milliseconds: 500),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.zero,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Form(
                  key: _formField,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Full Name',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible:
                            firstName.text.isEmpty || lastName.text.isEmpty,
                            child: Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //First and Last Name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                        });
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
                                      controller: firstName,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person,
                                            color: Colors.green[500]),
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                        labelText:
                                        'First Name', // Placeholder text
                                        labelStyle: TextStyle(
                                            color: Colors.grey[300],
                                            fontWeight: FontWeight.normal),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]!),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green[500]!),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                        });
                                      },
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Enter Last Name";
                                        }else{
                                          bool  isValidName = RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
                                          if(!isValidName){
                                            return "Invalid last name. It should not\ninclude numbers and symbols";
                                          }
                                        }
                                        return null;
                                      },
                                      controller: lastName,
                                      decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                        prefixIcon: Icon(Icons.person,
                                            color: Colors.white),
                                        labelText: 'Last Name', // Placeholder text
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey[300]),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[300]!),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.green[500]!),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),


                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Staff ID',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: staffId.text.isEmpty,
                            child: Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //staffId
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                            });
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
                          controller: staffId,
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.idCard,
                                color: Colors.green[500]),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                            hintText: 'CUC-xxx', // Placeholder text
                            hintStyle: TextStyle(
                                color: Colors.grey[300],
                                fontWeight: FontWeight.normal),
                            // Customize border
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[500]!),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),


                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Username',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: userName.text.isEmpty,
                            child: Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //UserName
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                            });
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
                          controller: userName,
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.at,
                                color: Colors.green[500]),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                            hintText: (firstName.text.isEmpty || lastName.text.isEmpty)
                                ?'Enter username'
                                :'${firstName.text.isNotEmpty ? firstName.text[0].toLowerCase() : ''}${lastName.text.toLowerCase()}', // Placeholder text
                            hintStyle: TextStyle(
                                color: Colors.grey[300],
                                fontWeight: FontWeight.normal),
                            // Customize border
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[500]!),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Contact Number',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: contactNumber.text.isEmpty,
                            child: Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //contact number
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                            });
                          },
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Contact Number";
                            }else{
                              bool  isValidName = RegExp(r'^09\d{9}').hasMatch(value);
                              if(!isValidName){
                                return "Invalid contact number";
                              }
                            }
                            return null;
                          },
                          controller: contactNumber,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.green[500],
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                            hintText: '09xxxxxxxxx', // Placeholder text
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.normal,
                            ),
                            // Customize border
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[500]!),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        )
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Position',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: _selectedRole.isEmpty,
                            child: Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //position
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.layers, color: Colors.green[500]),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                            hintText: _selectedRole.isEmpty ? 'Select Position' : _selectedRole,
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.normal,
                            ),
                            // Customize border
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[500]!),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          value: _selectedRole.isEmpty ? null : _selectedRole,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRole = newValue as String;
                            });
                          },
                          items: ['Driver', 'Helper']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please select a position';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: _passwordController.text.isEmpty,
                            child: Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                            });
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
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            prefixIcon:
                            Icon(Icons.lock, color: Colors.green[500]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[500]!),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: _confirmPasswordController.text.isEmpty,
                            child: Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),


                      //confirm password
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {

                            });
                          },
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter password again to confirm your password";
                            }else{
                              if(value!=_passwordController.text){
                                return "Password does not match";
                              }
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                          obscureText: _obscureTextConfirm,
                          decoration: InputDecoration(
                            prefixIcon:
                            Icon(Icons.lock, color: Colors.green[500]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureTextConfirm = !_obscureTextConfirm;
                                });
                              },
                            ),
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[500]!),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),


                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if(_formField.currentState!.validate()){

                              QuerySnapshot staffIdSnapshot = await FirebaseFirestore.instance
                                  .collection('Users')
                                  .where('staffId', isEqualTo: staffId.text.trim())
                                  .get();

                              QuerySnapshot usernameSnapshot = await FirebaseFirestore.instance
                                  .collection('Users')
                                  .where('userName', isEqualTo: userName.text.trim())
                                  .get();

                              if(staffIdSnapshot.docs.isNotEmpty){
                                showDialog(context: context, builder:
                                    (_) =>  AlertDialog(title: Text("Error",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                        fontSize: 20)),
                                        content:  Row(
                                          children: [
                                            Icon(Icons.sim_card_alert_outlined, color: Colors.red,),
                                            SizedBox(width: 5),
                                            Text('Account already exists for \n${staffId.text.trim()}'),
                                          ],
                                        ),));
                                return;

                              }
                              else if(usernameSnapshot.docs.isNotEmpty){
                                showDialog(context: context, builder:
                                    (_) =>  AlertDialog(title: Text("Error",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20)),
                                    content:  Row(
                                        children: [
                                          Icon(Icons.sim_card_alert_outlined, color: Colors.red,),
                                          SizedBox(width: 5),
                                          Text('Account already exists for \n'
                                              '${userName.text.trim()}'),
                                        ],
                                  ),));
                                return;
                              }
                              else{
                                User newUser = User(
                                    firstName: firstName.text.trim(),
                                    lastName: lastName.text.trim(),
                                    username: userName.text.trim(),
                                    departmentId: (_selectedRole=='Driver')?'OT_001':'OT_002',
                                    pictureUrl: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png',
                                    staffID: staffId.text.trim(),
                                    position: _selectedRole,
                                    registeredDate: getTimeDate(),
                                    contactNumber: contactNumber.text.trim(),
                                    password: _passwordController.text.trim()
                                );

                                createNewUser(newUser);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ApplicationApproval()),
                                );
                              }

                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.sim_card_alert_outlined, color: Colors.red,),
                                    SizedBox(width: 5),
                                    Text('Please correctly fill out all necessary fields to continue'),
                                  ],
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                // return light blue when pressed
                                return Colors.green[200]!;
                              }
                              // return blue when not pressed
                              return Colors.green[500]!;
                            },
                          ),
                          minimumSize:
                          MaterialStateProperty.all<Size>(Size(200, 50)),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                            ),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ), // Set text color
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApplicationApproval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ApplicationBody(),
      ),
    );
  }
}

class ApplicationBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/images/awaiting_approval.png')),
          Center(
            child: Text(
              'Account Created',
              style: TextStyle(
                color: Colors.green[500],
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text(
              "You will be contacted by management \n once your account has been approved.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center, // Align text to the center
            ),
          ),
        ],
      ),
    );
  }
}