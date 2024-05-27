import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../components/bottomTab.dart';
import '../components/data/user_information.dart';
import 'account_tab.dart';

class ChangePassword extends StatefulWidget {
  final User account;
  ChangePassword({
    Key? key,
    required this.account
  }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscureTextCurrent = true;
  bool _obscureTextNew = true;
  bool _obscureTextConfirm = true;

  TextEditingController _currentPass = TextEditingController();
  TextEditingController _newPass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();

  final _formField = GlobalKey<FormState>();

  bool isUpdating =false;


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                  child: Form(
                    key: _formField,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _currentPass,
                            obscureText: _obscureTextCurrent,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter current password to change password";
                              }else{
                                if(value!= widget.account.password){
                                  return "Password does not match";
                                }
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Current Password",
                              labelStyle: TextStyle(
                                color: Colors.black, // Font color
                                fontSize: 16, // Font size
                                fontStyle: FontStyle.italic, // Italic style
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !_obscureTextCurrent ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureTextCurrent = !_obscureTextCurrent;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Colors.green, // Customize border color when focused
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100], // Background color
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                            ),
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: Colors.grey,
                          ),
                          SizedBox(height: 20),

                          TextFormField(
                            controller: _newPass,
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
                            obscureText: _obscureTextNew,
                            decoration: InputDecoration(
                              labelText: "New Password",
                              labelStyle: TextStyle(
                                color: Colors.black, // Font color
                                fontSize: 16, // Font size
                                fontStyle: FontStyle.italic, // Italic style
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !_obscureTextNew ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureTextNew = !_obscureTextNew;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Colors.green, // Customize border color when focused
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100], // Background color
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                            ),
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: Colors.grey,
                          ),
                          SizedBox(height: 20),

                          TextFormField(
                            controller: _confirmPass,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter password again to confirm your password";
                              }else{
                                if(value!=_newPass.text.trim()){
                                  return "Password does not match";
                                }
                              }
                              return null;
                            },
                            obscureText: _obscureTextConfirm,
                            decoration: InputDecoration(
                              labelText: "Confirm New Password",
                              labelStyle: TextStyle(
                                color: Colors.black, // Font color
                                fontSize: 16, // Font size
                                fontStyle: FontStyle.italic, // Italic style
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !_obscureTextConfirm ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureTextConfirm = !_obscureTextConfirm;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Colors.green, // Customize border color when focused
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100], // Background color
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                            ),
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: Colors.grey,
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if(_formField.currentState!.validate()){
                    updatePassword();

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
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        // return light blue when pressed
                        return Colors.green[200]!;
                      }
                      // return blue when not pressed
                      return Colors.green[700]!;
                    },
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                  ),
                ),
                child: Text(
                  'Save',
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
        ),
      ),
      bottomNavigationBar: BottomTab(currIndex: 2,),
    );
  }

  Widget savingPassword() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountTab()),
        );
      },
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 60,
          ),
            SizedBox(height: 20),
            Text('Password has been updated',
              style: TextStyle(
                fontSize: 16,
              ),),
          ],
        ),
      ),
    );
  }


  void updatePassword() async {

    setState(() {
      isUpdating=true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return savingPassword();
      },
    );

    try
    {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('staffId', isEqualTo: widget.account.staffID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assume there's only one document with the matching staffID
        DocumentSnapshot document = querySnapshot.docs.first;

        // Update the document
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(document.id)
            .update({
          'password': _newPass.text.trim(),


        });
        setState(() {
          print('STOP');
          isUpdating =false;
        });
      } else {
        throw Exception('No user found with staffID: ${widget.account.staffID}');
      }
    } catch (e)
    {
      setState(() {
        isUpdating = false; // Set isUpdating to false if update fails
      });
      throw Exception('Failed to update user: $e');
    }

  }



}