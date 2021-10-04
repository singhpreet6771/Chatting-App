import 'package:custom_fade_animation/custom_fade_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickoff/utility/utils.dart';
import 'package:lottie/lottie.dart';


bool checkUserInFirebaseAuth() {
  // In case user has logged in or registered, FirebaseAuth Module saves that information locally on the device as token
  FirebaseAuth auth = FirebaseAuth.instance;
  if(auth.currentUser != null) {
    Utils.UID = auth.currentUser.uid;
    return true;
  }
  else{
    return false;
  }
}

navigate(BuildContext context, String route ){
  Future.delayed(
      Duration(seconds: 2),
          (){
        Navigator.pushReplacementNamed(context, route);
      }
  );
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if(checkUserInFirebaseAuth()){ // UID is not empty -> i.e. User has either logged in or registered
      navigate(context, "/home");
    }else{
      navigate(context, "/welcome");
    }
    return   Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        child: Center(
          child: Lottie.asset('assets/lottie/splash.json'),
        ),
      ),
    );
  }
}
