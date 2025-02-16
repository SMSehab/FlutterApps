import 'package:flutter/material.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/services/location.dart';
import 'package:kinbo/views/shared/loading.dart';
import 'package:kinbo/views/authenticate/auth.dart';
import 'package:kinbo/views/home/location_permission.dart';
import 'package:kinbo/views/home/mapview.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _showLocationDialog = false;
  final LocationService _locationService = LocationService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Add a listener to the user stream to know when it emits its first value
    final _userStream = Provider.of<UserObj?>(context, listen: false);
    _userStream == null ? _isLoading = true : _isLoading = false;
  }

  @override
  void dispose() {
    // Stop background location updates when the widget is disposed
    final _user = Provider.of<UserObj?>(context, listen: false);
    if (_user != null && _user.uid != null) {
      _locationService.stopBackgroundLocationUpdates();
    }
    _locationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserObj?>(context);
    final _permissionGranted = Provider.of<perm.PermissionStatus?>(context);
    final _locationEnabled = Provider.of<bool?>(context);

    // Show Loading() while waiting for the streams to emit their first values.
    if (_locationEnabled == null || _permissionGranted == null || _isLoading) {
      return Loading();
    }

    // 1. Authentication Check:
    if (_user == null) {
      return Authenticate();
    }

    // 2. Location/Permission Check:
    if (!_locationEnabled ||
        _permissionGranted == perm.PermissionStatus.denied ||
        _permissionGranted == perm.PermissionStatus.permanentlyDenied) {
      // Show the LocationPermissionPage as a dialog.
      if (!_showLocationDialog) {
        _showLocationDialog = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return LocationPermissionPage(
                onPermissionGranted: () {
                  setState(() {
                    _showLocationDialog = false;
                  });
                },
              );
            },
          );
        });
      }
      // Return an empty container to avoid showing any other UI while the dialog is active.
      return Container();
    }
    // reset the _showLocationDialog
    _showLocationDialog = false;

    // 3. Start background location updates:
    if (_locationEnabled && _user.uid != null) {
      _locationService.startBackgroundLocationUpdates(_user.uid);
    }

    // 4. Show MapView with data loading:
    return MultiProvider(
      providers: [
        StreamProvider<List<Friend>>.value(
            initialData: [], value: DatabaseService(uid: _user.uid).friends),
        StreamProvider<UserData>.value(
            initialData: UserData(),
            value: DatabaseService(uid: _user.uid).userData),
      ],
      child: MapView(uid: _user.uid),
    );
  }
}
