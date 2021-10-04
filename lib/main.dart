import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'authentication/starting_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



