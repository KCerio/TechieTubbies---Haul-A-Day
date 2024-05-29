import 'package:flutter/material.dart';

class PasswordSecurity extends StatelessWidget {
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

                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width:1000,
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                  onPressed: () {},
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
