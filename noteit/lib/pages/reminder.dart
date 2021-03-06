import 'package:flutter/material.dart';
import 'package:noteit/pages/datepicker.dart';

class Reminder extends StatelessWidget {
  const Reminder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ignore: deprecated_member_use
        accentColor: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
      ),
      home: const Scaffold(
        body: Center(
          child: DatePicker(),
        ),
      ),
    );
  }
}
