import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:whiteboardkit/drawing_controller.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:whiteboardkit/whiteboard.dart';

class Drawing extends StatefulWidget {
  const Drawing({Key? key}) : super(key: key);

  @override
  DrawingState createState() => DrawingState();
}

class DrawingState extends State<Drawing> {
  late DrawingController controller;

  @override
  void initState() {
    controller = DrawingController();
    controller.onChange().listen((draw) {});
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Whiteboard(
                controller: controller,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
