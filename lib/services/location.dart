import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinbo/services/database.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationService {
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  bool _isBackgroundLocationEnabled = false;

  // Controllers for streams
  final StreamController<bool> _locationEnabledController =
  StreamController<bool>.broadcast();
  final StreamController<perm.PermissionStatus> _permissionGrantedController =
  StreamController<perm.PermissionStatus>.broadcast();

  // Uploads my current location and time to database.
  uploadMyLocationData(String uid, LocationData location) async {
    if (location.latitude != null && location.longitude != null) {
      GeoPoint position = GeoPoint(location.latitude!, location.longitude!);
      DateTime now = DateTime.now();
      String time = DateFormat('h:mm a,   EEE, MMMM d y').format(now);
      print('User Data Uploading..........................');
      await DatabaseService(uid: uid)
          .updateUserData(location: position, time: time, uuid: uid);
    }
  }

  // requests user grant location access
  // and enable location service
  Future<perm.PermissionStatus> enableLocation() async {
    bool _serviceEnabled;
    perm.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _locationEnabledController.add(false);
        return perm.PermissionStatus.denied;
      }
    }
    _permissionGranted = await perm.Permission.location.status;
    if (_permissionGranted.isDenied) {
      _permissionGranted = await perm.Permission.location.request();
      if (_permissionGranted.isDenied) {
        _permissionGrantedController.add(perm.PermissionStatus.denied);
        return perm.PermissionStatus.denied;
      }
    }
    if (_permissionGranted.isGranted) {
      _permissionGranted = await perm.Permission.locationAlways.status;
      if (_permissionGranted.isDenied) {
        _permissionGranted = await perm.Permission.locationAlways.request();
      }
      if (_permissionGranted.isGranted) {
        _isBackgroundLocationEnabled = true;
      }
    }
    // Emit new values immediately after permission is granted
    _locationEnabledController.add(true);
    _permissionGrantedController.add(_permissionGranted);
    return _permissionGranted;
  }

  // gets new location data whenever location gets changed
  Stream<LocationData> get getLocation {
    return location.onLocationChanged;
  }

  // These streams constanty check for
  // user's location permission status
  // and location service status,
  // watches whether user turn off these services.
  Stream<bool> get locationEnabledStream {
    // Add the initial value
    location
        .serviceEnabled()
        .then((value) => _locationEnabledController.add(value));
    // Periodically check the service status and add it to the stream
    Timer.periodic(Duration(seconds: 3), (timer) async {
      bool isEnabled = await location.serviceEnabled();
      if (!_locationEnabledController.isClosed) {
        _locationEnabledController.add(isEnabled);
      } else {
        timer.cancel();
      }
    });
    return _locationEnabledController.stream;
  }

  Stream<perm.PermissionStatus> get permissionGrantedStream {
    // Add the initial value
    perm.Permission.location.status
        .then((value) => _permissionGrantedController.add(value));
    // Periodically check the permission status and add it to the stream
    perm.PermissionStatus? lastStatus;
    Timer.periodic(Duration(seconds: 3), (timer) async {
      perm.PermissionStatus currentStatus =
      await perm.Permission.location.status;
      if (lastStatus != currentStatus) {
        lastStatus = currentStatus;
        if (!_permissionGrantedController.isClosed) {
          _permissionGrantedController.add(currentStatus);
        } else {
          timer.cancel();
        }
      }
    });
    return _permissionGrantedController.stream;
  }

  // Start listening to location changes in the background
  void startBackgroundLocationUpdates(String? uid) {
    // Start listening to location changes regardless of background permission
    _locationSubscription = location.onLocationChanged.listen((locationData) {
      uploadMyLocationData(uid!, locationData);
    });
  }

  // Stop listening to location changes
  void stopBackgroundLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  void dispose() {
    _locationEnabledController.close();
    _permissionGrantedController.close();
  }
}

