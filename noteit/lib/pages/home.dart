import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/speech_api.dart';
import '../utils/routes.dart';
import 'package:avatar_glow/avatar_glow.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

get color => null;

class _HomeState extends State<Home> {
  String text = 'Press the button and start speaking';
  bool isListening = false;
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
              ),
              Container(
                alignment: const Alignment(1.00, -0.65),
                child: const Text(
                  'NoteIt',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 78.0,
                    fontFamily: 'Daniel',
                  ),
                ),
              ),
              Container(
                alignment: const Alignment(1.00, 3.91),
                width: 120,
                height: 120,
                child: const ClipOval(
                  child: Align(
                    alignment: Alignment.center,
                    heightFactor: 0.615,
                    widthFactor: 0.615,
                    child: Image(
                      image: AssetImage('assets/images/Untitled.jpg'),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: const Alignment(1.00, 0),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
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
                  Navigator.pushNamed(context, NoteitRoutes.calroute);
                },
              ),
              ListTile(
                leading:
                    const Icon(CupertinoIcons.book, color: Colors.deepPurple),
                title: const Text('Notes'),
                onTap: () {
                  Navigator.pushNamed(context, NoteitRoutes.noteroute);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.hand_draw,
                    color: Colors.deepPurple),
                title: const Text('Drawing'),
                onTap: () {
                  Navigator.pushNamed(context, NoteitRoutes.drawroute);
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: isListening,
          endRadius: 75,
          glowColor: Colors.white,
          child: FloatingActionButton(
            child: const Icon(Icons.mic_none, size: 36),
            backgroundColor: Colors.deepPurple,
            onPressed: toggleRecording,
          ),
        ),
      ),
    );
  }

  toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);

          /*if (!isListening) {
            Future.delayed(const Duration(seconds: 3), () {
              //Utils.scanText(text);
            });
          }*/
        },
      );
}
