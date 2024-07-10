import 'dart:convert';

import 'package:app/pages/main_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late double width, height;
  bool checkState = false, splashScreen = true, isLoading = false;
  static late SharedPreferences data;
  late String folderPath;
  late String? userName, userPhoto;
  static late final Map<String, dynamic> assets;

  @override
  void initState() {
    super.initState();

    loadAssets();

    getLoginState();
  }

  void getLoginState() async {
    data = await SharedPreferences.getInstance();
    checkState = data.getBool('login_state') ?? false;
    userName = data.getString('user_name');
    userPhoto = data.getString('user_photo');
    if (checkState) {
      navigateTo(userName, userPhoto);
    } else {
      setState(() {
        splashScreen = false;
      });
    }
  }

  void navigateTo(String? name, String? image) {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    });
  }

  void googleLogin(context) async {
    try {
      setState(() {
        isLoading = true;
      });

      if ((await Connectivity().checkConnectivity()).first ==
          ConnectivityResult.none) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Internet connection required'),
          ),
        );
      } else {
        var user = await GoogleSignIn().signIn().onError((error, stackTrace) {
          setState(() {
            isLoading = false;
          });
          return null;
        });

        if (user != null) {
          data.setBool('login_state', true);
          data.setString('user_name', user.displayName ?? '');
          data.setString('user_photo', user.photoUrl ?? '');
          navigateTo(user.displayName, user.photoUrl);
        }
        try {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await user!.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
        } on FirebaseAuthException {
          //
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
    return true;
  }

  Future<void> loadAssets() async {
    try {
      assets = json.decode(await rootBundle.loadString('AssetManifest.json'));
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.shortestSide;
    height = MediaQuery.of(context).size.longestSide;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assests/home_background.jpg'),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            // Center(
            //     child: Container(
            //       padding: EdgeInsets.all(width * 0.05),
            //       decoration: BoxDecoration(
            //           color: Colors.black.withOpacity(0.7),
            //           borderRadius: BorderRadius.vertical(
            //               top: Radius.circular(width * 0.5),
            //               bottom: Radius.circular(width * 0.1))),
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           // Opacity(
            //           //   opacity: 0.8,
            //           //   // child: Container(
            //           //   //   // width: width * 0.5,
            //           //   //   // height: width * 0.5,
            //           //   //
            //           //   //
            //           //   // ),
            //           // ),
            //           SizedBox(height: width * 0.03),
            //           Container(
            //             padding: EdgeInsets.symmetric(
            //                 horizontal: width * 0.04, vertical: width * 0.02),
            //             decoration: BoxDecoration(
            //                 color: Colors.black.withOpacity(1),
            //                 borderRadius: BorderRadius.vertical(
            //                     top: Radius.circular(width * 0.5),
            //                     bottom: Radius.circular(width * 0.1))),
            //             child: Text('',
            //                 style: TextStyle(
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: width * 0.05)),
            //           ),
            //         ],
            //       ),
            //     )),
            GestureDetector(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                googleLogin(context);
              },
              child: Center(
                child: Container(
                    height: 70,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: height * 0.02),
                    padding: EdgeInsets.all(height * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(height * 0.02),
                    ),
                    child: Center(
                      child: Text(
                        'Login with Google',
                        style: TextStyle(
                            fontSize: height * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )),
              ),
            ),
            if (isLoading)
              Center(
                  child: SizedBox(
                      width: height * 0.05,
                      height: height * 0.05,
                      child: const CircularProgressIndicator(
                          color: Colors.white))),
            if (splashScreen)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Center(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(height * 0.1),
                  child: Image.asset('assests/avatar.jpg',
                      width: height * 0.2, height: height * 0.2),
                )),
              ),
          ],
        ),
      ),
    );
  }
}
