import 'package:custom_fade_animation/custom_fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.all(15.0),
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            FadeAnimation(1,Container(
                child: Center(
                  child: Text("Text Anytime, Anywhere!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: size.width*0.06),),
                ),
              )),
          FadeAnimation(1.5,Container(
                height: size.height*0.5,
                padding: EdgeInsets.only(top: 10.0),
                child: Lottie.asset('assets/lottie/welcome.json'),
              )),
              SizedBox(height: size.height*0.10,),
          FadeAnimation(2,Container(
            width: 210,
            child: MaterialButton(
              child: Text("GET STARTED", style: TextStyle(fontSize: 18.0),),
              onPressed: () {
                Navigator.pushNamed(context, "/signup");
              },
              height: 60.0,
              elevation: 3.0,
              textColor: Colors.white,
              color: Colors.cyan,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
          ),
          ),
            ],
          ),
        ),
      )
    );
  }
}
