import 'package:flutter/material.dart';
import 'package:sqf_lite_test_app/model/notes.dart';
import 'package:sqf_lite_test_app/update_notes.dart';

class AllNotes extends StatefulWidget {
  String sortOrder;

  AllNotes({this.sortOrder: "ASC"});

  @override
  _AllNotesState createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  bool loading = false, isLongPressed = false;
  List checkedList = List();
  List checkedListContainerData = List();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String retrievedNote;
  List notes = List();
  bool clickedToShowNote = false;
  Icon leadingIcon = Icon(Icons.keyboard_arrow_up);
  ScrollController _listListenerController = ScrollController();

  loadNotes({int lastId}) {
    Notes().retrieve(sortOrder: widget.sortOrder, lastId: lastId).then((value) {
      setState(() {
        notes.addAll(value);
        loading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadNotes();
    _listListenerController.addListener(() {
      if (_listListenerController.position.pixels ==
          _listListenerController.position.maxScrollExtent) {
        int lastId = notes[notes.length - 1]['id'];
        // print(notes[notes.length - 1]['id']);
        setState(() {
          loading = true;
        });
        loadNotes(lastId: lastId);
      }
      // else if (_listListenerController.position.pixels ==
      //     _listListenerController.position.minScrollExtent) {
      //   int lastId = notes[0]['id'];
      //   loadNotes(lastId: lastId);
      //   setState(() {
      //     loading = true;
      //   });
      // }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listListenerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: !loading ? Text("My Recent Notes") : Text("Loading data...."),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                if (widget.sortOrder == "DESC") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllNotes(
                          sortOrder: "ASC",
                        ),
                      ));
                } else {
                  setState(() {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllNotes(
                            sortOrder: "DESC",
                          ),
                        ));
                  });
                }
              },
            ),
            IconButton(
                color: Colors.white,
                disabledColor: Colors.grey.shade500,
                icon: Icon(Icons.delete),
                onPressed: checkedList.length > 0
                    ? () {
                        if (checkedList.isNotEmpty) {
                          Notes().deleteAll(checkedItems: checkedList);
                          if (checkedList.length == 1) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("One Item Deleted Successfully"),
                              ),
                            );
                          } else if (checkedList.length > 1) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Items Deleted Successfully"),
                              ),
                            );
                          }
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllNotes(),
                              ));
                        } else {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content:
                                  Text("Select one or more items to deleted"),
                            ),
                          );
                        }
                      }
                    : null)
          ],
        ),
        body: showAllNotes(),
      ),
    );
  }

  showAllNotes() {
    if (notes != null && notes.length > 0) {
      return ListView.builder(
        controller: _listListenerController,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                trailing: isLongPressed
                    ? Checkbox(
                        value: checkedList.contains(notes[index]['id']),
                        onChanged: (value) {
                          setState(() {
                            checkedList.contains(notes[index]['id'])
                                ? checkedList.remove(notes[index]['id'])
                                : checkedList.add(notes[index]['id']);
                          });
                        },
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      ),
                leading: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateNote(
                              notes[index]["id"], notes[index]["note"]),
                        ));
                  },
                ),
                title: Text("Note ${index + 1} :"),
                subtitle: notes[index]["note"].toString().length > 10
                    ? Text(
                        "${notes[index]["note"].toString().substring(0, 10)}.....")
                    : Text("${notes[index]["note"].toString()}"),
                onTap: () {
                  if (clickedToShowNote) {
                    setState(() {
                      clickedToShowNote = false;
                    });
                  } else {
                    setState(() {
                      clickedToShowNote = true;
                    });
                  }
                  if (!checkedListContainerData.contains(index)) {
                    setState(() {
                      checkedListContainerData.clear();
                      checkedListContainerData.add(index);
                    });
                    leadingIcon = Icon(Icons.keyboard_arrow_down);
                  } else {
                    setState(() {
                      checkedListContainerData.clear();
                      leadingIcon = Icon(Icons.keyboard_arrow_up);
                    });
                  }
                },
                onLongPress: () {
                  if(isLongPressed){
                    setState(() {
                      isLongPressed = false;
                    });
                  }else{
                    setState(() {
                      isLongPressed = true;
                    });
                  }

                },
              ),
              drawContainerOfData(index),
              Divider(
                color: Colors.grey.shade800,
                indent: 60,
                endIndent: 60,
              )
            ],
          );
        },
      );
    } else if (notes == null) {
      return Column(
        children: [
          Text("No Notes Added yet , Let's Create New Notes"),
          Center(
              child: FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Add New Notes",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
          )),
        ],
      );
    }
  }

  drawContainerOfData(int index) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: (clickedToShowNote && checkedListContainerData.contains(index))
          ? Center(
              child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.grey,
                width: 1,
              )),
              child: Text("${notes[index]["note"]}"),
            ))
          : Container(),
    );
  }
}
