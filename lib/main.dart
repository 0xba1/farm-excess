import 'package:farm_excess/screens/home.dart';
import 'package:farm_excess/values/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // To ensure that firebase loads completely before widgets
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Excess',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: MyColors.kiwi,
      ),
      home: Home(),
    );
  }
}
