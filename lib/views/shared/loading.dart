import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


// A loading window whenever data get delayed to load.

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.indigo[300],
          size: 50.0,
        ),
      ),
    );
  }
}