import 'package:flutter/material.dart';
import 'package:noteit/utils/routes.dart';
import '../utils/routes.dart';
import '../pages/home.dart';
import '../pages/calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        NoteitRoutes.homeroute: (context) => Home(),
        NoteitRoutes.calroute: (context) => Calendar(),
        //MyRoutes.loginRoute: (context) => LoginPage()
      },
    );
  }
}
