import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: unused_import
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:noteit/pages/timezone.dart';
import 'package:noteit/utils/routes.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key key}) : super(key: key);
  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateTime dt;
  TimeOfDay time;

  final _formKey = GlobalKey<FormState>();
  Map<int, String> monthsInYear = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };
  FlutterLocalNotificationsPlugin fltrNotification =
      FlutterLocalNotificationsPlugin();

  List alarms = [];
  int counter = 0;
  List<Item> reminders;
  String reminder;
  @override
  void initState() {
    super.initState();
    dt = DateTime.now();
    time = TimeOfDay.now();
    var androidInitialize = const AndroidInitializationSettings('app_icon');
    var iOSinitialize = const IOSInitializationSettings();
    // ignore: unnecessary_new
    var initilizationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSinitialize);
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future _sNotification(DateTime scheduledTime, int id) async {
    var androidDetails = const AndroidNotificationDetails(
        "1", "Reminder", "NoteitNotificationChannel",
        importance: Importance.max);
    var iOSDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        // ignore: unnecessary_new
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    final timeZone = TimeZone();

    // The device's timezone.
    String timeZoneName = await timeZone.getTimeZoneName();

    // Find the 'current location'
    final location = await timeZone.getLocation(timeZoneName);

    final st = tz.TZDateTime.from(scheduledTime, location);
    fltrNotification.zonedSchedule(
        counter, "Reminder", alarms[id][4], st, generalNotificationDetails,
        androidAllowWhileIdle: true,
        payload:
            '${alarms[id][4]} at ${alarms[id][1].hourOfPeriod}:${DatePickerState().getminute(alarms[id][1])} ${DatePickerState().getm(alarms[id][1])}',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    setState(() {
      alarms[id][2] = st;
      alarms[id][3] = counter;
      counter = counter + 1;
    });
  }

  Future cancelAllNotifications() async {
    await fltrNotification.cancelAll();
    setState(() {
      alarms = [];
      reminders = generateItems(alarms);
    });
  }

  Future cancelNotification(int id, int index) async {
    await fltrNotification.cancel(id);
    setState(() {
      alarms.removeAt(index);
      reminders.removeAt(index);
    });
  }

  tz.TZDateTime _nextInstanceOf(int index) {
    final now = alarms[index][2];
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _scheduleDailyNotification(int index) async {
    await fltrNotification.zonedSchedule(
        counter,
        'Daily Notification',
        'Daily Reminder',
        _nextInstanceOf(index),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'index',
            'Daily notification',
            'Daily Reminder',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);

    setState(() {
      counter = counter + 1;
    });
  }

  Future<void> _scheduleWeeklyNotification(int index) async {
    await fltrNotification.zonedSchedule(
        counter,
        'Weekly Notification',
        'Weekly Reminder',
        _nextInstanceOf(index),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'index', 'Weekly notification', 'Weekly Reminder'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
    setState(() {
      counter = counter + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reminder',
          style: TextStyle(fontSize: 24),
        ),
        // automaticallyImplyLeading: false,
        // leading: const BackButton(
        //   color: Colors.white,
        // ),

        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              cancelAllNotifications();
            },
          )
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: <Widget>[
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                reminders[index].isExpanded = !isExpanded;
              });
            },
            children: reminders?.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) {
                        return Row(children: [
                          Expanded(
                              child: ListTile(
                            title: Text(item.headerValue),
                          )),
                          // IconButton(icon: Icon(Icons.edit), onPressed: null),
                          Switch(
                            value: item.toggle,
                            onChanged: (value) {
                              setState(() {
                                item.toggle = !item.toggle;
                                if (!value) {
                                  fltrNotification.cancel(item.id);
                                }
                                if (value) {
                                  _sNotification(
                                      alarms[reminders.indexOf(item)][2],
                                      reminders.indexOf(item));
                                }
                              });
                            },
                          )
                        ]);
                      },
                      body: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                item.expandedValue,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              )),
                            ),
                            IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                ),
                                color: Colors.purple[900],
                                onPressed: () {
                                  editReminder(reminders.indexOf(item));
                                }),
                            IconButton(
                                color: Colors.purple[900],
                                icon: const Icon(
                                  Icons.event,
                                ),
                                onPressed: () {
                                  editDate(context, reminders.indexOf(item));
                                }),
                            IconButton(
                                color: Colors.purple[900],
                                icon: const Icon(
                                  Icons.access_time,
                                ),
                                onPressed: () {
                                  editTime(context, reminders.indexOf(item));
                                }),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                cancelNotification(
                                    alarms[reminders.indexOf(item)][3],
                                    reminders.indexOf(item));
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    2.0, 0.0, 0.0, 20.0),
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.alarm,
                                        color: item.dailyColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (item.daily) {
                                            fltrNotification.cancel(item.did);
                                            item.dailyColor = Colors.black;
                                            item.daily = false;
                                          } else {
                                            item.did = counter;
                                            _scheduleDailyNotification(
                                                reminders.indexOf(item));
                                            item.dailyColor = Colors.red;
                                            item.daily = true;
                                          }
                                        });
                                      },
                                    ),
                                    const Text('Daily Reminder')
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        2.0, 0.0, 0.0, 20.0),
                                    child: Column(children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.alarm,
                                          color: item.weeklyColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (item.weekly) {
                                              fltrNotification.cancel(item.wid);
                                              item.weeklyColor = Colors.black;
                                              item.weekly = false;
                                            } else {
                                              item.wid = counter;
                                              _scheduleWeeklyNotification(
                                                  reminders.indexOf(item));
                                              item.weeklyColor = Colors.red;
                                              item.weekly = true;
                                            }
                                          });
                                        },
                                      ),
                                      const Text('Weekly'),
                                    ]))),
                          ],
                        )
                      ]),
                      isExpanded: item.isExpanded);
                })?.toList() ??
                [],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickDate(context, null);
        },
        child: const Icon(Icons.event),
        tooltip: 'Add',
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future picktime(BuildContext context, int index) async {
    TimeOfDay tod = TimeOfDay.now();
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: (index != null)
          ? alarms[index][1]
          : TimeOfDay(
              hour: tod.hour,
              minute: (tod.minute == 59) ? tod.minute : tod.minute + 1),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            // dialogTheme:
          ),
          child: child,
        );
      },
    );
    if (t != null) {
      int l = alarms.length;
      time = t;
      index = l;
      DateTime st =
          dt.add(Duration(hours: t.hour, minutes: t.minute, seconds: 5));

      setState(() {
        setReminder();
        if (st.isAfter(DateTime.now())) {
          _sNotification(st, index);
          if (reminder != null) {
            alarms.insert(l, [dt, time, false, counter, reminder]);
            reminder = null;
            reminders = generateItems(alarms);
          }
        }
      });
    }
  }

  Future pickDate(BuildContext context, int index) async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: (index != null) ? alarms[index][0] : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.deepPurple,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            // dialogTheme:
          ),
          child: child,
        );
      },
    );
    if (date != null) {
      setState(() {
        dt = date;
      });
      picktime(context, index);
    }
  }

  getminute(t) {
    if (t.minute < 10) {
      return "0" + t.minute.toString();
    } else {
      return t.minute;
    }
  }

  getm(t) {
    if (t.period.toString() == "DayPeriod.am") {
      return "am";
    } else {
      return "pm";
    }
  }

  setReminder() async {
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
                      onSaved: (input) => reminder = input,
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
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                Navigator.pop(context, reminder);
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

  editDate(BuildContext context, int index) async {
    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: alarms[index][0],
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.deepPurple,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            // dialogTheme:
          ),
          child: child,
        );
      },
    );
    if (newDate != null) {
      List newdateTime = [newDate, alarms[index][1], false];
      if (newdateTime[0] != alarms[index][0] ||
          newdateTime[1] != alarms[index][1]) {
        DateTime nst = dt.add(Duration(
            hours: alarms[index][1].hour, minutes: alarms[index][1].minute));
        await fltrNotification.cancel(alarms[index][3]);
        await _sNotification(nst, index);
        setState(() {
          alarms[index][0] = newdateTime[0];
          alarms[index][1] = newdateTime[1];
          reminders = generateItems(alarms);
        });
      }
    }
  }

  editTime(BuildContext context, int index) async {
    TimeOfDay newtime = await showTimePicker(
      context: context,
      initialTime: alarms[index][1],
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            // dialogTheme:
          ),
          child: child,
        );
      },
    );
    if (newtime != null) {
      List newdateTime = [alarms[index][0], newtime, false];

      if (newdateTime[0] != alarms[index][0] ||
          newdateTime[1] != alarms[index][1]) {
        DateTime nst = newdateTime[0]
            .add(Duration(hours: newtime.hour, minutes: newtime.minute));
        await fltrNotification.cancel(alarms[index][3]);
        await _sNotification(nst, index);
        setState(() {
          alarms[index][0] = newdateTime[0];
          alarms[index][1] = newdateTime[1];
          reminders = generateItems(alarms);
        });
      }
    }
  }

  editAlarm(BuildContext context, int index) async {
    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: alarms[index][0],
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.deepPurple,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            // dialogTheme:
          ),
          child: child,
        );
      },
    );
    if (newDate != null) {
      TimeOfDay newtime = await showTimePicker(
        context: context,
        initialTime: alarms[index][1],
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
              // dialogTheme:
            ),
            child: child,
          );
        },
      );
      if (newtime != null) {
        List newdateTime = [newDate, newtime, false];

        if (newdateTime[0] != alarms[index][0] ||
            newdateTime[1] != alarms[index][1]) {
          DateTime nst =
              dt.add(Duration(hours: newtime.hour, minutes: newtime.minute));
          await fltrNotification.cancel(alarms[index][3]);
          await _sNotification(nst, index);
          setState(() {
            alarms[index][0] = newdateTime[0];
            alarms[index][1] = newdateTime[1];
            reminders = generateItems(alarms);
          });
        }
      }
    }
  }

  editReminder(int index) async {
    await setReminder();
    if (reminder != null) {
      setState(() {
        alarms[index][4] = reminder;
        DateTime st = alarms[index][0].add(Duration(
            hours: alarms[index][1].hour, minutes: alarms[index][1].minute));
        fltrNotification.cancel(alarms[index][3]);
        _sNotification(st, index);
        reminders = generateItems(alarms);
      });
    }
  }
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
    this.daily = false,
    this.did = 0,
    this.wid = 0,
    // this.monthly = false,
    this.weekly = false,
    this.dailyColor = Colors.black,
    this.weeklyColor = Colors.black,
    this.toggle = true,
    this.id,
    // this.monthlyColor = Colors.black,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
  bool daily;
  bool weekly;
  bool toggle;
  int did;
  int wid;
  int id;
  // bool monthly;
  Color dailyColor;
  Color weeklyColor;
  // Color monthlyColor;
}

List<Item> generateItems(List reminders) {
  return List.generate(reminders.length, (int index) {
    return Item(
      id: reminders[index][3],
      headerValue: '${reminders[index][4]}',
      expandedValue:
          '${reminders[index][0].day} ${DatePickerState().monthsInYear[reminders[index][0].month]} ${reminders[index][0].year} , ${reminders[index][1].hourOfPeriod}:${DatePickerState().getminute(reminders[index][1])} ${DatePickerState().getm(reminders[index][1])}',
    );
  });
}
