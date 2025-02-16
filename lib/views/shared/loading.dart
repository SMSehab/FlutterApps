
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Icon(
          Icons.hourglass_empty, // Or any other icon
          size: 50.0,
          color: Colors.indigo[300],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
//
// // A loading window whenever data get delayed to load.
//
// class Loading extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Center(
//         child: SpinKitChasingDots(
//           color: Colors.indigo[300],
//           size: 50.0,
//         ),
//       ),
//     );
//   }
// }