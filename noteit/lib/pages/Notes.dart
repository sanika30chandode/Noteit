// ignore_for_file: file_names, prefer_final_fields, prefer_is_empty, unnecessary_new, deprecated_member_use, prefer_const_constructors, avoid_print, unnecessary_string_interpolations, duplicate_ignore

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:noteit/utils/NotesPage.dart';
import '../utils/NotesPage.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    notesDescriptionMaxLenth =
        notesDescriptionMaxLines * notesDescriptionMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple[400],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: notesHeader(),
      ),
      body: noteHeading.length > 0
          ? buildNotes()
          : Center(
              child: Text("Add Notes...",
                  style: TextStyle(
                    color: Colors.deepPurple[400],
                    fontSize: 29,
                  ))),
      floatingActionButton: FloatingActionButton(
        mini: false,
        backgroundColor: Colors.deepPurple[400],
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        // ignore: prefer_const_constructors
        child: Icon(Icons.create),
      ),
    );
  }

  Widget buildNotes() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: new ListView.builder(
        itemCount: noteHeading.length,
        itemBuilder: (context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.5),
            child: new Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                setState(
                  () {
                    deletedNoteHeading = noteHeading[index];
                    deletedNoteDescription = noteDescription[index];
                    noteHeading.removeAt(index);
                    noteDescription.removeAt(index);
                    Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        backgroundColor: Colors.deepPurple[300],
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Text(
                              "Note Deleted",
                              style: TextStyle(),
                            ),
                            deletedNoteHeading != ""
                                ? GestureDetector(
                                    onTap: () {
                                      print("undo");
                                      setState(
                                        () {
                                          if (deletedNoteHeading != "") {
                                            noteHeading.add(deletedNoteHeading);
                                            noteDescription
                                                .add(deletedNoteDescription);
                                          }
                                          deletedNoteHeading = "";
                                          deletedNoteDescription = "";
                                        },
                                      );
                                    },
                                    child: new Text(
                                      "Undo",
                                      style: TextStyle(),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              background: ClipRRect(
                borderRadius: BorderRadius.circular(5.5),
                child: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              secondaryBackground: ClipRRect(
                borderRadius: BorderRadius.circular(5.5),
                child: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child: noteList(index),
            ),
          );
        },
      ),
    );
  }

  Widget noteList(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: noteColor[(index % noteColor.length).floor()],
          borderRadius: BorderRadius.circular(5.5),
        ),
        height: 100,
        child: Center(
          child: Row(
            children: [
              new Container(
                color:
                    noteMarginColor[(index % noteMarginColor.length).floor()],
                width: 3.5,
                height: double.infinity,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          noteHeading[index],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.00,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.5,
                      ),
                      Flexible(
                        child: SizedBox(
                          height: double.infinity,
                          child: AutoSizeText(
                            "${(noteDescription[index])}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.00,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 50,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (MediaQuery.of(context).size.height),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 250, top: 50),
                  child: new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New Note",
                            style: TextStyle(
                              fontSize: 20.00,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  noteHeading.add(noteHeadingController.text);
                                  noteDescription
                                      .add(noteDescriptionController.text);
                                  noteHeadingController.clear();
                                  noteDescriptionController.clear();
                                });
                                Navigator.pop(context);
                              }
                              print("Notes.dart LineNo:239");
                              print(noteHeadingController.text);
                            },
                            child: Row(
                              children: const [
                                Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 20.00,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.deepPurple.shade400,
                        thickness: 2.5,
                      ),
                      TextFormField(
                        maxLength: notesHeaderMaxLenth,
                        controller: noteHeadingController,
                        cursorColor: Colors.deepPurple[400],

                        decoration: InputDecoration(
                          hintText: "Note Heading",
                          hintStyle: TextStyle(
                            fontSize: 15.00,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.text_fields,
                            color: Colors.grey,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple.shade400,
                              width: 2.0,
                            ),
                          ),
                        ),

                        // ignore: missing_return
                        validator: (noteHeading) {
                          if (noteHeading!.isEmpty) {
                            return "Please enter Note Heading";
                          } else if (noteHeading.startsWith(" ")) {
                            return "Please avoid whitespaces";
                          }
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context)
                              .requestFocus(textSecondFocusNode);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: 5 * 24.0,
                          child: TextFormField(
                            focusNode: textSecondFocusNode,
                            maxLines: notesDescriptionMaxLines,
                            maxLength: notesDescriptionMaxLenth,
                            controller: noteDescriptionController,
                            cursorColor: Colors.deepPurple[400],
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepPurple.shade400,
                                  width: 2.0,
                                ),
                              ),
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                fontSize: 15.00,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // ignore: missing_return
                            validator: (noteDescription) {
                              if (noteDescription!.isEmpty) {
                                return "Please enter Note Description";
                              } else if (noteDescription.startsWith(" ")) {
                                return "Please avoid whitespaces";
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget notesHeader() {
  return Padding(
    padding: const EdgeInsets.only(
      top: 10,
      left: 2.5,
      right: 2.5,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "NoteIt",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.00,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
