import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Colors.white,
        child: Center(
          child: SpinKitRotatingPlain(
            color: Colors.indigoAccent,
            size: 50,
          ),
        ),
      ),
    );
  }
}
