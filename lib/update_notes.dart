import 'package:flutter/material.dart';
import 'package:sqf_lite_test_app/all_notes_page.dart';
import 'package:sqf_lite_test_app/model/notes.dart';

class UpdateNote extends StatefulWidget {
  int id;
  String noteData;

  UpdateNote(this.id, this.noteData);

  @override
  _UpdateNoteState createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  GlobalKey <ScaffoldState>_scaffoldKey=GlobalKey();
  GlobalKey<FormFieldState> _fieldKey = GlobalKey();
  String _noteData;

  @override
  _updateNote() async {
    if (_fieldKey.currentState.validate()) {
      _fieldKey.currentState.save();
      print(await Notes().update(id: widget.id, note:_noteData));
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Note Updated Successfully..."),));
      Navigator.push(
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
                      initialValue: widget.noteData,
                      // textAlignVertical: TextAlignVertical.center,
                      scrollPadding: EdgeInsets.all(5),
                      key: _fieldKey,
                      maxLines: 20,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.blue.shade200, width: 2),
                        ),
                        labelText: "New Note",
                        prefixIcon: Icon(Icons.article_outlined),
                        hintText: "Type Your Note...",
                        contentPadding: EdgeInsets.only(left: 20, top: 20),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Edit Your Note!";
                        }
                      },
                      onSaved: (newValue) {
                        _noteData = newValue;
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _updateNote();
                    },
                    child: Text(
                      "Update Note ${widget.id}",
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
