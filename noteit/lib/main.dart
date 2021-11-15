import 'package:flutter/material.dart';
import 'package:noteit/utils/routes.dart';
import 'utils/routes.dart';
import 'pages/home.dart';
import 'pages/calendar.dart';
import 'pages/drawing.dart';
import 'pages/Notes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const Home(),
        NoteitRoutes.homeroute: (context) => const Home(),
        NoteitRoutes.calroute: (context) => Calendar(),
        NoteitRoutes.drawroute: (context) => Drawing(),
        NoteitRoutes.noteroute: (context) => const NotesPage(),
        //MyRoutes.loginRoute: (context) => LoginPage()
      },
    );
  }
}
