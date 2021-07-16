import 'package:flutter/material.dart';
import 'package:kinbo/services/location.dart';
import 'package:location/location.dart';

class LocationPermissionPage extends StatelessWidget {
  // const LocationPermission({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      body: AlertDialog(
        title: Text('Location access required!',
        style: TextStyle(
              fontSize: 22.00),),
        content: Text(
          "Provide Location Permission so that your friends be able to see where you are and you can see where they are. Your location is always shared among all users. ",
          softWrap: true,
        ),
        actions: [
          TextButton(
            child: Text(
              ' Agree & give access ',
              style: TextStyle(color: Colors.white,
              fontSize: 15.00),
            ),
            style: TextButton.styleFrom(
              //primary: Colors.green[400],
              backgroundColor: Colors.indigo[300],
              padding: EdgeInsets.all(10.0),
              minimumSize: Size(200, 40),

              
            ),
            onPressed: () async {
              LocationService().enableLocation();
            },
          )
        ],
        elevation: 24.0,
      ),
    );
  }
}
