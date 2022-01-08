import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteit/model/note.dart';

// final _lightColors = [
//   Colors.amber.shade300,
//   Colors.lightGreen.shade300,
//   Colors.lightBlue.shade300,
//   Colors.orange.shade300,
//   Colors.pinkAccent.shade100,
//   Colors.tealAccent.shade100
// ];

final _lightColors = [
  Colors.pink.shade50,
  Colors.green.shade50,
  Colors.blue.shade50,
  Colors.orange.shade50,
  Colors.indigo.shade50,
  Colors.red.shade50,
  Colors.yellow.shade50,
  Colors.brown.shade50,
  Colors.teal.shade50,
  Colors.purple.shade50,
];
// ignore: unused_element
final _lightMarginColors = [
  Colors.pink.shade500,
  Colors.green.shade300,
  Colors.blue.shade300,
  Colors.orange.shade300,
  Colors.indigo.shade300,
  Colors.red.shade300,
  Colors.yellow.shade300,
  Colors.brown.shade300,
  Colors.teal.shade300,
  Colors.purple.shade300,
];

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key key,
    this.note,
    this.index,
  }) : super(key: key);

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              note.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
