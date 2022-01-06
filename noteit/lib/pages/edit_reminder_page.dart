import 'package:flutter/material.dart';
import 'package:noteit/db/reminder_database.dart';
import 'package:noteit/model/Reminder_model.dart';
import 'package:noteit/pages/reminder.dart';

class AddEditReminderPage extends StatefulWidget {
  final Reminder reminder;

  const AddEditReminderPage({
    Key key,
    this.reminder,
  }) : super(key: key);
  @override
  _AddEditReminderPageState createState() => _AddEditReminderPageState();
}

class _AddEditReminderPageState extends State<AddEditReminderPage> {
  String description;

  @override
  void initState() {
    super.initState();
    description = widget.reminder?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
          backgroundColor: Colors.deepPurple,
        ),
        //body: ,
      );

  Widget buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.deepPurple,
        ),
        //onPressed: addOrUpdateReminder,
        child: const Text('Save'),
      ),
    );
  }
}
