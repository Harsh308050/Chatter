import 'dart:developer';

import 'package:chat_app/API/APIs.dart';
import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:chat_app/Screens/auth/LoginScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Color.fromARGB(146, 0, 110, 255),
          statusBarColor: Color.fromARGB(146, 0, 110, 255)));

      if (APIs.auth.currentUser != null) {
        log('\nUser::------${APIs.auth.currentUser}');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            top: size.height - 550,
            width: size.width - 150,
            left: size.width - 290,
            child: Image.asset(
              'assets/images/icon.png',
            )),
        Positioned(
            bottom: size.height - 550,
            width: size.width - 20,
            child: const Text(
              "MADE BY HARSH",
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 1, fontSize: 18, color: Colors.black),
            )),

        //google button
      ],
    ));
  }
}
