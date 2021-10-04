import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickoff/authentication/signup.dart';
import 'package:flutter_kickoff/authentication/splash_page.dart';
import 'package:flutter_kickoff/authentication/welcome_page.dart';
import 'package:flutter_kickoff/homepages/homepage.dart';
import 'package:flutter_kickoff/homepages/searchContactsPage.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      routes: {
        "/": (context) => SplashPage(),
        "/welcome": (context) => WelcomePage(),
        "/signup": (context) => Signup(),
        "/home": (context) => HomePage(),
        "/searchContactPage": (context) => SearchContactPage(),
      },
      initialRoute: "/",
    );
  }
}