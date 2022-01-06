// ignore_for_file: file_names, prefer_const_declarations, unnecessary_this

final String tableReminders = 'reminder';

class ReminderFields {
  static final List<String> values = [
    /// Add all fields
    id, description, time
  ];

  static final String id = '_id';
  static final String description = 'description';
  static final String time = 'time';
}

class Reminder {
  final int id;
  final String description;
  final DateTime time;

  const Reminder({
    this.id,
    this.description,
    this.time,
  });

  Reminder copy({
    int id,
    String description,
    DateTime time,
  }) =>
      Reminder(
        id: id ?? this.id,
        description: description ?? this.description,
        time: time ?? this.time,
      );

  static Reminder fromJson(Map<String, Object> json) => Reminder(
        id: json[ReminderFields.id] as int,
        description: json[ReminderFields.description] as String,
        time: DateTime.parse(json[ReminderFields.time] as String),
      );

  Map<String, Object> toJson() => {
        ReminderFields.id: id,
        ReminderFields.description: description,
        ReminderFields.time: time.toIso8601String(),
      };
}
