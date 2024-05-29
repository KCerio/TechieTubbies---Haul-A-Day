import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/userService.dart';

class PasswordSecurity extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  const PasswordSecurity({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<PasswordSecurity> createState() => _PasswordSecurityState();
}

class _PasswordSecurityState extends State<PasswordSecurity> {
  UserService userService = UserService();
  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController reTypeController = TextEditingController();
  final _formfield = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
      child: Container(
        width: 1000,
        height: 560,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 30, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Itim',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(120, 30, 0, 0),
                  child: Text(
                    'Password should contain 8-12 characters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontFamily: 'Itim',
                    ),
                  ),
                ),
                Form(
                  key: _formfield,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(70, 60, 0, 0),
                        child: Material(
                          child: Container(
                            width: 800,
                            height: 60,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(
                                  5.0), // Match the border radius
                            ),
                            child: TextFormField(
                              controller: currentController,
                              obscureText: true,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter current password";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Current Password",
                                labelStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(70, 10, 0, 0),
                        child: Material(
                          child: Container(
                            width: 800,
                            height: 60,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(
                                  5.0), // Match the border radius
                            ),
                            child: TextFormField(
                              controller: newController,
                              obscureText: true,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter new password";
                                }else{
                                  bool  isValidPassword = RegExp(r'^(?=.*[a-zA-Z\d])[a-zA-Z\d]{8,12}$').hasMatch(value);
                                  if(!isValidPassword){
                                    return "Password should contain 8 - 12 characters.";
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "New Password",
                                labelStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(70, 10, 0, 0),
                        child: Material(
                          child: Container(
                            width: 800,
                            height: 60,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(
                                  5.0), // Match the border radius
                            ),
                            child: TextFormField(
                              controller: reTypeController,
                              obscureText: true,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Re-type new password";
                                } else{
                                  bool  isValidPassword = RegExp(r'^(?=.*[a-zA-Z\d])[a-zA-Z\d]{8,12}$').hasMatch(value);
                                  if(!isValidPassword){
                                    return "Password should contain 8 - 12 characters.";
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Re-type Password",
                                labelStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width:1000,
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                  onPressed: () async{
                    if(_formfield.currentState!.validate()){
                      String currentpw = currentController.text;
                      String newpw = newController.text;
                      String reTypepw = reTypeController.text;

                      if(currentpw == widget.userInfo['password']){
                        if(newpw == reTypepw){
                          widget.userInfo['password'] = newpw;
                          bool updated = await userService.updatePassword(newpw, widget.userInfo['staffId']);
                          if(updated){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Updated'),
                                  content: const Text('Your password is updated.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {        
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }else{
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
                                        CircularProgressIndicator(),
                                        SizedBox(height: 20),
                                        Text('Updating...'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }else{
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Alert'),
                                content: const Text('Re-typed password does not match new password!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {        
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else{
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('Incorrect current password!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {        
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontFamily: 'Itim', fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3871C1),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
