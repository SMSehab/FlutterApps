import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinbo/services/database.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

class LocationService {
  Location location = Location();
  LocationData currentPosition;

  uploadMyLocationData(String uid, LocationData location) async {
    if (location.latitude != null && location.latitude != null) {
      GeoPoint position = GeoPoint(location.latitude, location.longitude);
      DateTime now = DateTime.now();
      String time = DateFormat('dd-MM – kk:mm').format(now);
      print('user data uploading.........');
      await DatabaseService(uid: uid)
          .updateUserData(location: position, time: time, uuid: uid);
    }
  }

  Future enableLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      // if (!_serviceEnabled) {
      //   return null;
      // }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      // if (_permissionGranted != PermissionStatus.granted) {
      //   return null;
      // }
    }
    return currentPosition = await location.getLocation();
  }

  Stream<LocationData> get getLocation {
    location.getLocation();
    return location.onLocationChanged;
  }

  Stream<bool> locationEnabled() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield await location.serviceEnabled();
    }
  }

  Stream<bool> get locationEnabledStream {
    return locationEnabled();
  }

  Stream<PermissionStatus> permissionGranted() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield await location.hasPermission();
    }
  }

  Stream<PermissionStatus> get permissionGrantedStream {
    return permissionGranted();
  }
}
