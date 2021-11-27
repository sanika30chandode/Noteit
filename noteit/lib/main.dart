import 'package:flutter/material.dart';
import 'package:noteit/utils/routes.dart';
import 'pages/note_page.dart';
import 'utils/routes.dart';
import 'pages/home.dart';
import 'pages/calendar.dart';
import 'pages/drawing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

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
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
    );
  }
}
