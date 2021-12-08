import 'package:flutter/material.dart';
import 'package:noteit/utils/routes.dart';
import 'pages/note_page.dart';
import 'utils/routes.dart';
import 'pages/home.dart';
import 'pages/calendar.dart';
import 'pages/drawing.dart';
import 'pages/reminder.dart';
import 'package:noteit/pages/reminder.dart';

import 'package:timezone/data/latest_all.dart' as tz;

// ignore: unused_import
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const Home(),
        NoteitRoutes.homeroute: (context) => const Home(),
        NoteitRoutes.calroute: (context) => const Calendar(),
        NoteitRoutes.drawroute: (context) => Drawing(),
        NoteitRoutes.noteroute: (context) => const NotesPage(),
        NoteitRoutes.reminderroute: (context) => const Reminder(),
        //MyRoutes.loginRoute: (context) => LoginPage()
      },
      theme: ThemeData(
          // ignore: deprecated_member_use
          accentColor: Colors.deepPurple),
    );
  }
}
