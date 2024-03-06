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
    return Scaffold(
      backgroundColor: Color.fromARGB(255,102,179,101),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/truck.png",
                ),
                // username textfield
                TextField(
                  onChanged: (value){
                    adminusername = value;
                  }, style: const TextStyle(fontSize: 16,  color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Username or Staff ID",
                      hintStyle: TextStyle(color: Color.fromARGB(153, 255, 255, 255))
                      //enabledBorder: OutlineInputBorder(
                      //borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1)
                    //),
                  )
                ),

                const SizedBox(height: 10,),

                 // password textfield
                TextField(
                  onChanged: (value){
                    adminpassword = value;
                  }, 
                    obscureText: true,
                    style: const TextStyle(fontSize: 16,  color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Color.fromARGB(153, 255, 255, 255))
                      //enabledBorder: OutlineInputBorder(
                      //borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1)
                    //),
                  )
                  ),
                   const SizedBox(height: 30,),
                    //login button
                    ElevatedButton(
                      onPressed: (){

                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),
                      ), 
                      child: const Text("Login",
                      style: TextStyle(
                        color: Colors.white, 
                        letterSpacing:2, 
                        fontSize: 16),  
                      ))
                  ],
                  ),
                  )
                  )
                  ],
        ),

    );
  }

}