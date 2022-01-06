import 'package:flutter/material.dart';
import 'package:noteit/db/reminder_database.dart';
import 'package:noteit/model/Reminder_model.dart';
import 'package:noteit/pages/edit_reminder_page.dart';
import 'package:noteit/utils/NotesPage.dart';
import 'package:noteit/utils/notification_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key key}) : super(key: key);

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  List<Reminder> reminders;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  String description;
  NotificationService _notificationService = NotificationService();
  @override
  void initState() {
    super.initState();

    refreshReminders();
  }

  Future refreshReminders() async {
    setState(() => isLoading = true);

    reminders = await ReminderDatabase.instance.readAllReminders();

    setState(() => isLoading = false);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
      picktime(context);
    }
  }

  Future<void> picktime(BuildContext context) async {
    TimeOfDay tod = TimeOfDay.now();
    final TimeOfDay pickedtime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: tod.hour,
          minute: (tod.minute == 59) ? tod.minute : tod.minute + 1),
    );
    if (pickedtime != null) {
      setState(() {
        date = date.add(Duration(
            hours: pickedtime.hour, minutes: pickedtime.minute, seconds: 5));
      });
      setdescription();
      //_notificationService.scheduleNotifications(
      //    1, 'title', 'description', date);
    }
  }

  setdescription() async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(children: [
        Container(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.deepPurple,
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) => (value == "")
                          ? "Please Enter Reminder Details"
                          : null,
                      onSaved: (input) => description = input,
                      decoration: InputDecoration(
                        labelText: 'Enter Reminder Details',
                        labelStyle: const TextStyle(
                          color: Colors.deepPurple,
                        ),
                        focusColor: Colors.deepPurple,
                        fillColor: Colors.deepPurple,
                        hoverColor: Colors.deepPurple,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ReminderPage()),
                                );
                              }
                            },
                            child: const Text('Submit'))
                      ],
                    )
                  ],
                ))),
      ]),
    );
  }

  Future addReminder() async {
    final reminder = Reminder(
      description: description,
      time: date,
    );

    await ReminderDatabase.instance.create(reminder);
  }

  /*Widget buildReminders() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: reminders.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = reminders[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id),
              ));

              refreshReminders();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );*/

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : reminders.isEmpty
                    ? Text(
                        "${date.day}/${date.month}/${date.year}/${date.hour}/${date.minute}/${date.second}",
                        //'Add Reminders',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 24),
                      )
                    //:buildReminders(),
                    : Text(
                        "${date.day}/${date.month}/${date.year}/${date.hour}/${date.minute}/${date.second}",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 24),
                      )),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.add),
            onPressed: () {
              selectDate(context);

              /*onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ReminderPage()),
              );*/
              refreshReminders();
            }),
      );
}
