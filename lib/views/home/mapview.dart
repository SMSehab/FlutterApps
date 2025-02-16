
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/create_markers.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/views/user_panel/user_panel.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../shared/loading.dart';

// shows all friends on google map,
// shows their profile pic as marker,
class MapView extends StatefulWidget {
  final String? uid;

  MapView({this.uid});
  //const MapView({ Key? key }) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Location location = Location();

  Completer<GoogleMapController> _controller = Completer();

  LatLng _malekMamaTeaShop = const LatLng(23.7262622, 90.3803007);

  MapType _currentMapType = MapType.normal;

  Map<String, BitmapDescriptor> icons = {};
  Future<void>? _markerIconFuture;

  //Set<Marker> markers = {Marker(markerId: MarkerId('d'))};

  @override
  void initState() {
    super.initState();
    // gets all friends marker icon initially.
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-fetch data when the widget's dependencies change (e.g., when returning from another page)
    _fetchData();
  }

  // gets the markers.
  Future<void> _fetchData() async {
    if (widget.uid == null) {
      print('Error: widget.uid is null');
      return;
    }
    try {
      List<Friend?> buddyListForImage =
      await DatabaseService(uid: widget.uid).buddyImages();
      List<Friend> filteredBuddies =
      buddyListForImage.whereType<Friend>().toList();
      icons = await CreateMarkers().imageIcon(filteredBuddies);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error in _getMarkerIcon: $e');
    }
  }

  // toggles map between normal view and satellite view.
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<Friend>>(context) ?? [];
    final userData = Provider.of<UserData?>(context);

    Set<Marker> markers = CreateMarkers().createMarkers(friends, icons);
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: _malekMamaTeaShop,
            zoom: 12.0,
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
                const SizedBox(height: 40.0),
                FloatingActionButton(
                  heroTag: 'me',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => UserPanel(),
                      ),
                    );
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.indigo[300],
                  shape: const CircleBorder(),
                  child: (userData != null && userData.image != null)
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(userData.image!),
                    radius: 30,
                  )
                      : const Icon(
                    Icons.person,
                    size: 35.00,
                  ),
                ),
                const SizedBox(height: 16.0),
                FloatingActionButton(
                  heroTag: 'mapView',
                  onPressed: _onMapTypeButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.indigo[300],
                  shape: const CircleBorder(),
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


