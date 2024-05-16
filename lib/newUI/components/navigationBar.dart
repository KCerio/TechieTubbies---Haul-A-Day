import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/controllers/menuController.dart';
import 'package:haul_a_day_web/newUI/components/sidepanel.dart';
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
                  showSettingsMenu(context);
                },
                child: Container(
                  //margin: const EdgeInsets.only(left: 24),
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
                        backgroundImage:NetworkImage(userInfo['pictureUrl'])
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

  void showSettingsMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 60, 60, 25, 0);

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Handle Profile option
              Navigator.pop(context); // Close the menu
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Handle Settings option
              Navigator.pop(context); // Close the menu
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log-out'),
            onTap: () {
              Provider.of<SideMenuSelection>(context, listen: false)
                    .setSelectedTab(TabSelection.Home);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const login_screen()),
                );
            },
          ),
        ),
      ],
    );
  }
}