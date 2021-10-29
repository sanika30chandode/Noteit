import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import './drawing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get color => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'APPS.inc',
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/images/home_background.png",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,

                //alignment: Alignment.center,
              ),
              Container(
                  alignment: const Alignment(-0.05, -0.65),
                  child: const Text(
                    'NoteIt',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 78.0,
                      fontFamily: 'Daniel',
                    ),
                  )),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // ignore: sized_box_for_whitespace
              Container(
                height: 130.0,
                child: const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.rectangle,
                  ),
                  child: Text(
                    "NoteIt Drawer",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading:
                    const Icon(CupertinoIcons.alarm, color: Colors.deepPurple),
                title: const Text('Alarms'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.calendar,
                    color: Colors.deepPurple),
                title: const Text('Calender'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    const Icon(CupertinoIcons.book, color: Colors.deepPurple),
                title: const Text('Notes'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.hand_draw,
                    color: Colors.deepPurple),
                title: const Text('Drawing'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    const Icon(CupertinoIcons.pen, color: Colors.deepPurple),
                title: const Text('Quick Notes'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              /*
              ListTile(
                leading: Icon(CupertinoIcons.person, color: Colors.deepPurple),
                title: const Text('Diary'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
