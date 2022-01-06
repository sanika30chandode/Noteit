import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:noteit/model/Reminder_model.dart';

class ReminderDatabase {
  static final ReminderDatabase instance = ReminderDatabase._init();

  static Database _database;

  ReminderDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('reminder.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableReminders (
  ${ReminderFields.id} $idType,
  ${ReminderFields.description} $textType,
  ${ReminderFields.time} $textType
)
''');
  }

  Future<Reminder> create(Reminder reminder) async {
    final db = await instance.database;
    final id = await db.insert(tableReminders, reminder.toJson());
    return reminder.copy(id: id);
  }

  Future<Reminder> readReminder(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableReminders,
      columns: ReminderFields.values,
      where: '${ReminderFields.id}=?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Reminder.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Reminder>> readAllReminders() async {
    final db = await instance.database;
    final orderBy = '${ReminderFields.time} ASC';
    final result = await db.query(tableReminders, orderBy: orderBy);
    return result.map((json) => Reminder.fromJson(json)).toList();
  }

  Future<int> update(Reminder reminder) async {
    final db = await instance.database;

    return db.update(
      tableReminders,
      reminder.toJson(),
      where: '${ReminderFields.id} = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableReminders,
      where: '${ReminderFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
