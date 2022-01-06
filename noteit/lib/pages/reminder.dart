import 'package:flutter/material.dart';
import 'package:noteit/pages/datepicker.dart';

class Reminders extends StatelessWidget {
  const Reminders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ignore: deprecated_member_use
        accentColor: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Reminder',
            style: TextStyle(fontSize: 24),
          ),
          automaticallyImplyLeading: true,
          // leading: const BackButton(
          //   color: Colors.white,
          // ),

          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            )
          ],
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(
          child: DatePicker(),
        ),
      ),
    );
  }
}
