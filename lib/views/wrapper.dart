import 'package:flutter/material.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/services/location.dart';
import 'package:kinbo/views/shared/loading.dart';
import 'package:kinbo/views/authenticate/auth.dart';
import 'package:kinbo/views/home/location_permission.dart';
import 'package:kinbo/views/home/mapview.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  //const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserObj>(context);
    final _locationData = Provider.of<LocationData>(context);
    final _permissionGranted = Provider.of<PermissionStatus>(context);
    final _locationEnabled = Provider.of<bool>(context);

    print(_locationData);
    if (_user != null ) {
      LocationService().uploadMyLocationData(_user.uid, _locationData);
    }
    if (_locationEnabled != null) {
      return (_user == null)
          ? Authenticate()
          : ((!_locationEnabled) ||
                  _permissionGranted == PermissionStatus.denied ||
                  _permissionGranted == PermissionStatus.deniedForever ||
                  _user.uid == null)
              ? LocationPermissionPage()
              : MultiProvider(
                  providers: [
                    StreamProvider<List<Friend>>.value(
                        initialData: null,
                        value: DatabaseService(uid: _user.uid).friends),
                    StreamProvider<UserData>.value(
                        initialData:null,
                        value: DatabaseService(uid: _user.uid).userData),
                  ],
                  child: MapView(
                      uid: _user
                          .uid), 
                );
    } else {
      return Loading();
    }
  }
}
