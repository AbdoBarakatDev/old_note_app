import 'package:flutter/material.dart';
import 'package:sqf_lite_test_app/home_page.dart';

main() {
  runApp(MyNoteSaverApp());
}

class MyNoteSaverApp extends StatefulWidget {
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
