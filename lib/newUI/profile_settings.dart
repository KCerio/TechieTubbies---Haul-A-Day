import 'package:flutter/material.dart';

class Profile_Settings extends StatefulWidget {
  const Profile_Settings({super.key});

  @override
  State<Profile_Settings> createState() => _Profile_SettingsState();
}

class _Profile_SettingsState extends State<Profile_Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints){
          return Container(child: Center(child: Text('Profile & Settings Page',),),);
        },
      ),
    );
  }
}