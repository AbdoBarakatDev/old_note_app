import 'package:flutter/material.dart';
import 'package:sqf_lite_test_app/all_notes_page.dart';
import 'package:sqf_lite_test_app/model/notes.dart';

class CreateNote extends StatefulWidget {
  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  GlobalKey <ScaffoldState>_scaffoldKey=GlobalKey();
  GlobalKey<FormFieldState> _fieldKey = GlobalKey();
  String _noteData;

  _createNewNote() async {
    if (_fieldKey.currentState.validate()) {
      _fieldKey.currentState.save();
      print(await Notes().creat({"note": _noteData}));
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Note Updated Successfully..."),));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AllNotes(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Add New Notes"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      // textAlignVertical: TextAlignVertical.center,
                      scrollPadding: EdgeInsets.all(5),
                      key: _fieldKey,
                      maxLines: 20,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.blue.shade200, width: 2),
                        ),
                        labelText: "New Note",
                        prefixIcon: Icon(Icons.article_outlined),
                        hintText: "Type Your Note...",
                        contentPadding: EdgeInsets.only(left: 20,top: 20),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Type Your Note!";
                        }
                      },
                      onSaved: (newValue) {
                        _noteData = newValue;
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _createNewNote();
                    },
                    child: Text(
                      "Add Note",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
