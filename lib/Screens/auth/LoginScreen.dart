import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../API/APIs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _handleGoogleBtnClick() {
    dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log('\nUser::------${user.user}');
        log('\nUser Additional User Info::------${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      dialogs.showSnackBar(context, "Something Went Wrong ");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Image.asset(
            'assets/images/ManChatting.png',
          ),
          Container(
            child: const Column(
              children: [
                Text(
                  "Welcome To Let's Chat",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Hello, Please Login Through Google To Chat",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          ElevatedButton.icon(
            onPressed: () {
              _handleGoogleBtnClick();
            },
            style: ElevatedButton.styleFrom(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                backgroundColor: Colors.white,
                shadowColor: Colors.blueAccent,
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            icon: Image.asset(
              "assets/images/google.png",
              height: 40,
            ),
            label: const Text(
              "  Continue With Google",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
      //  Stack(
      //   children: [
      //     //man Icon
      //     Positioned(
      //         top: size.height - 720,
      //         width: size.width - 20,
      //         left: size.width - 350,
      //         child: Image.asset(
      //           'assets/images/ManChatting.png',
      //         )),

      //     //google button
      // ,Positioned(
      //     top: size.height - 200,
      //     width: size.width - 20,
      //     height: size.height * .07,
      //     left: size.width - 350,
      //     child: ElevatedButton.icon(
      //       onPressed: () {
      //         _handleGoogleBtnClick();
      //       },
      //       style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.white,
      //           shadowColor: Colors.blueAccent,
      //           elevation: 1.5,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10))),
      //       icon: Image.asset(
      //         "assets/images/google.png",
      //         height: 40,
      //       ),
      //       label: const Text(
      //         "  Continue With Google",
      //         style: TextStyle(color: Colors.black, fontSize: 16),
      //       ),
      //     )),
      // Positioned(
      //     bottom: size.height - 470,
      //     width: size.width - 20,
      //     height: size.height * .07,
      //     left: size.width - 350,
      //     child: Container(
      //       child: const Column(
      //         children: [
      //           Text(
      //             "Welcome To Let's Chat",
      //             style: TextStyle(
      //                 color: Colors.blue,
      //                 fontSize: 25,
      //                 fontWeight: FontWeight.bold),
      //           )
      //         ],
      //       ),
      //     )),
      // Positioned(
      //     bottom: size.height - 510,
      //     width: size.width - 20,
      //     height: size.height * .07,
      //     left: size.width - 350,
      //     child: Container(
      //       child: const Column(
      //         children: [
      //           Text(
      //             "Hello, Please Login Through Google To Chat",
      //             style: TextStyle(
      //               color: Colors.black,
      //               fontSize: 16,
      //             ),
      //           )
      //         ],
      //       ),
      //     )),
      //   ],
      // )
    );
  }
}
