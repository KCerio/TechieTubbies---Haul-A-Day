import 'package:firebase_core/firebase_core.dart';
import 'package:haul_a_day_web/controllers/menuController.dart';
import 'package:haul_a_day_web/newUI/components/addTruck.dart';
import 'package:haul_a_day_web/newUI/components/setpayrate.dart';
import 'package:haul_a_day_web/newUI/components/sidepanel.dart';
import 'package:haul_a_day_web/newUI/homescreen.dart';
import 'package:haul_a_day_web/newUI/orderdashboard.dart';
import 'package:haul_a_day_web/newUI/orderdashboard.dart';
import 'package:haul_a_day_web/page/order.dart';
//import 'package:haul_a_day_web/trial_pages/homepagetrial.dart';
//import 'package:haul_a_day_web/page/menupage2.dart';
import 'package:haul_a_day_web/page/orderpage.dart';
import 'package:haul_a_day_web/page/staffList.dart';
import 'package:haul_a_day_web/page/truck_list.dart';
import 'package:haul_a_day_web/trial_pages/ImageUploadTrial.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  runApp(ChangeNotifierProvider(
      create: (_) => SideMenuSelection(),
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haul-A-Day Website',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: login_screen() //AddTruck()
    );
  }
}

