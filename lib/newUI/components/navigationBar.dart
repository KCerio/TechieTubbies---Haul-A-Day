import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/controllers/menuController.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NavigationTopBar extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  const NavigationTopBar({super.key,required this.userInfo});

  @override
  Widget build(BuildContext context) {
    //print('Nav $userInfo');
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: context.read<MenuAppController>().controlMenu,
                icon: const Icon(Icons.menu, color: Colors.black,)
              ),
              const SizedBox(width: 10,),
              SizedBox(
                width: size.width *0.1,
                child: Image.asset(
                  'images/logo1.png',
                  fit: BoxFit.scaleDown,
                )
              ),
              const Spacer(flex: 2,),
          
          
              //user Container
              InkWell(
                onTap: () {
                  
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(235, 104, 209, 108),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20, // Adjust the size of the circle
                        backgroundImage:Image.asset('images/user_pic.png', ).image
                      ), //User Pic
                      //const Text("User's Name"), // User's Fullname
                      const SizedBox(width: 5,),
                      const Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
              )
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          )
        ],
      ),
    );
  }
}