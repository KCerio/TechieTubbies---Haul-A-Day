import 'package:flutter/material.dart';

import '../components/bottomTab.dart';
import '../components/data/user_information.dart';

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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                              child: TextFormField(
                                obscureText: _obscureTextCurrent,
                                decoration: InputDecoration(
                                  labelText: "Type current password",
                                  labelStyle: TextStyle(
                                    color: Colors.black, // Font color
                                    fontSize: 16, // Font size
                                    fontStyle: FontStyle.italic, // Italic style
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureTextCurrent
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureTextCurrent =
                                        !_obscureTextCurrent;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                cursorColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                              child: TextFormField(
                                obscureText: _obscureTextNew,
                                decoration: InputDecoration(
                                  labelText: "Type new password",
                                  labelStyle: TextStyle(
                                    color: Colors.black, // Font color
                                    fontSize: 16, // Font size
                                    fontStyle: FontStyle.italic, // Italic style
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureTextNew
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureTextNew = !_obscureTextNew;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                cursorColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                              child: TextFormField(
                                obscureText: _obscureTextConfirm,
                                decoration: InputDecoration(
                                  labelText: "Confirm new password",
                                  labelStyle: TextStyle(
                                    color: Colors.black, // Font color
                                    fontSize: 16, // Font size
                                    fontStyle: FontStyle.italic, // Italic style
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureTextConfirm
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureTextConfirm =
                                        !_obscureTextConfirm;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                cursorColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  // Add your onPressed logic here
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
}