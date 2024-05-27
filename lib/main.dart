import 'package:firebase_core/firebase_core.dart';
import 'package:haul_a_day_web/web_Pages/customerPage/homepage.dart';
import 'package:haul_a_day_web/web_Pages/otherComponents/sidepanel.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';


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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: CustomerHomePage()//login_screen() //AddTruck()
    );
  }
}

