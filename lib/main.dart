import 'package:firebase_core/firebase_core.dart';

import 'Screens/SplashScreen.dart';
import 'package:flutter/material.dart';

late Size size;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color appBarColor = Color.fromARGB(146, 0, 110, 255);
    Color appBarIconColor = Color.fromARGB(255, 247, 247, 247);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Kanit",
          appBarTheme: AppBarTheme(
              elevation: 3,
              backgroundColor: appBarColor,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  fontFamily: 'Kanit',
                  color: appBarIconColor,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
              iconTheme: IconThemeData(color: appBarIconColor, size: 25)),
        ),
        home: SplashScreen());
  }
}
