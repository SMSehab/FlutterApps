import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/create_markers.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/views/profile/profile.dart';
import 'package:kinbo/views/profile/user_panel.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  final String uid;

  MapView({this.uid});
  //const MapView({ Key? key }) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Location location = Location();

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _malekMama = const LatLng(23.7262622, 90.3803007);

  MapType _currentMapType = MapType.normal;

  Set<Marker> markers = {Marker(markerId: MarkerId('d'))};

  @override
  void initState() {
    _getMarkerData();
    super.initState();
  }

  Future<void> _getMarkerData() async {
    List<Buddy> buddyListForImage = await DatabaseService().buddyImages();
    markers = await CreateMarkers().createMarkers(buddyListForImage);
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final buddies = Provider.of<List<Buddy>>(context) ?? [];
    final userData = Provider.of<UserData>(context);
    final _locationData = Provider.of<LocationData>(context);
    print('-----------mapViewBuild');
    print(_locationData);
    print(userData);

    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: _malekMama,
            zoom: 15.0,
          ),
          mapType: _currentMapType,
          markers: markers,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                SizedBox(height: 40.0),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => UserPanel(),
                      ),
                    );
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.indigo[300],
                  child: (userData != null && userData.image != null)
                      ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(userData.image),
                                fit: BoxFit.fill),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 35.00,
                        ),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: _onMapTypeButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.indigo[300],
                  child: const Icon(Icons.map, size: 30.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
