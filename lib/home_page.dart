import 'package:flutter/material.dart';
import 'package:sqf_lite_test_app/all_notes_page.dart';
import 'package:sqf_lite_test_app/create_new_note_page.dart';
import 'package:sqflite/sqflite.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note App"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateNote(),
                      ));
                },
                child: Text(
                  "New Note",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllNotes(),
                      ));
                },
                child: Text(
                  "Show All Notes",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
