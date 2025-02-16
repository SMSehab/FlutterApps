
import 'package:flutter/material.dart';
import 'package:kinbo/services/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:location/location.dart';

class LocationPermissionPage extends StatelessWidget {
  final VoidCallback onPermissionGranted;

  const LocationPermissionPage({Key? key, required this.onPermissionGranted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Location access required!',
        style: TextStyle(fontSize: 22.00),
      ),
      content: Text(
        "Provide Location Permission so that your friends be able to see where you are and you can see where they are. ",
        softWrap: true,
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.indigo[300],
            padding: EdgeInsets.all(10.0),
            minimumSize: Size(200, 40),
          ),
          child: Text(
            ' Agree & give access ',
            style: TextStyle(color: Colors.white, fontSize: 15.00),
          ),
          onPressed: () async {
            // Request location permission
            perm.PermissionStatus permission =
            await LocationService().enableLocation();

            if (permission.isGranted) {
              // Check if location service is enabled
              bool serviceEnabled =
              await LocationService().location.serviceEnabled();
              if (!serviceEnabled) {
                serviceEnabled =
                await LocationService().location.requestService();
              }
              if (serviceEnabled) {
                onPermissionGranted();
                Navigator.of(context).pop();
              }
            }
          },
        )
      ],
      elevation: 24.0,
    );
  }
}


