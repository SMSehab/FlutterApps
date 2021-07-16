// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:kinbo/model/buddy.dart';
// import 'package:kinbo/model/user.dart';
// import 'package:kinbo/services/database.dart';
// import 'package:kinbo/views/home/mapview.dart';
// import 'package:provider/provider.dart';

// class GetMapData extends StatelessWidget {
//   //const GetMapData({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // final buddies = Provider.of<List<Buddy>>(context) ?? [];
//     // final _user = Provider.of<UserObj>(context);
//     // Set<Marker> markers = {};
//     // for (int i = 0; i < buddies.length; i++) {
//     //   Buddy userData = buddies[i];
//     //   if (userData.location != null) {
//     //     final Marker marker = Marker(
//     //       markerId: MarkerId(userData.uid),
//     //       position:
//     //           LatLng(userData.location.latitude, userData.location.longitude),
//     //       infoWindow: InfoWindow(
//     //         title: userData.name,
//     //         snippet: userData.time,
//     //       ),
//     //       // // Image conversion jon left .
//     //       icon: BitmapDescriptor.defaultMarker,
//     //     );
//     //     markers.add(marker);
//     //   }
//     // }
//     // print('MapViewPage------------- size of markers' + markers.length.toString());


//     return MultiProvider(
//       providers: [
//         StreamProvider<UserData>.value(
//             value: DatabaseService(uid: _user.uid).userData),
//       ],
//       child: MapView(
//         uid: _user.uid,
//         buddyList: buddies,
//         markerss: markers,
//       ),
//     );
//   }
// }
