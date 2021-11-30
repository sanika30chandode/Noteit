const String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, title, description, time
  ];

  static String id = '_id';
  static String title = 'title';
  static String description = 'description';
  static String time = 'time';
}

class Note {
  final int id;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    this.title,
    this.description,
    this.createdTime,
  });

  Note copy({
    int id,
    String title,
    String description,
    DateTime createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Note fromJson(Map<String, Object> json) => Note(
        id: json[NoteFields.id] as int,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
      );

  Map<String, Object> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.time: createdTime.toIso8601String(),
      };
}
