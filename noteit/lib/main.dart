import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/images/home_background.png",
                fit: BoxFit.cover,
                height: 781.1,
                width: 400,
                //alignment: Alignment.center,
              ),
              Container(
                  alignment: const Alignment(-0.05, -0.80),
                  child: const Text(
                    'Noteit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 83.0,
                      fontFamily: 'Daniel',
                    ),
                  )),
            ],
          ),
        ),
        drawer: const Drawer(),
      ),
    );
  }
}
