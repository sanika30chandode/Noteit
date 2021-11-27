// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/speech_api.dart';
import '../utils/routes.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

get color => null;

class _HomeState extends State<Home> {
  String text = 'Press the button and start speaking';
  String stext = '';
  bool isListening = false;
  bool isSpeaking = false;
  final _flutterTts = FlutterTts();

  void initializeTts() {
    _flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    _flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  void speak() async {
    if (stext.isNotEmpty) {
      await _flutterTts.speak(stext);
      stext = '';
    }
  }

  void stop() async {
    await _flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NoteIt",
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
                "assets/images/bg3.jpg",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Container(
                alignment: const Alignment(0.70, -0.65),
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
                alignment: const Alignment(1.00, 0),
                width: 140,
                height: 320,
                child: AvatarGlow(
                  animate: isListening,
                  endRadius: 75,
                  glowColor: Colors.white,
                  child: RawMaterialButton(
                    fillColor: Colors.deepPurple,
                    shape: const CircleBorder(),
                    elevation: 0.0,
                    child: const ImageIcon(
                      AssetImage('assets/images/logo_tr.png'),
                      size: 80,
                      color: Colors.white,
                    ),
                    onPressed: toggleRecording,
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
      ),
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);

          if (!isListening) {
            Future.delayed(const Duration(seconds: 3), () {
              scanText(text);
            });
          }
        },
      );

  void scanText(String rawText) {
    text = rawText.toLowerCase();

    if (text.contains("drawing")) {
      stext = 'opening drawing';
      isSpeaking ? stop() : speak();
      Navigator.pushNamed(context, NoteitRoutes.drawroute);
    } else if (text.contains("notes")) {
      stext = 'opening notes';
      isSpeaking ? stop() : speak();
      Navigator.pushNamed(context, NoteitRoutes.noteroute);
    } else if (text.contains("calendar")) {
      stext = 'opening calendar';
      isSpeaking ? stop() : speak();
      Navigator.pushNamed(context, NoteitRoutes.calroute);
    }

    text = "";
  }
}
