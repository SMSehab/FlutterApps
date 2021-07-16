import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kinbo/model/buddy.dart';
//import 'package:image/image.dart' as Images;

class CreateMarkers {
  // Method to convert image into marker-icon
  Future<Map<String, BitmapDescriptor>> _imageIcon(List<Buddy> buddies) async {
    Map<String, BitmapDescriptor> userIdMarkerMap = {};

    for (int i = 0; i < buddies.length; i++) {
      if (buddies[i].image != null) {
        final File imageAsFile =
            await DefaultCacheManager().getSingleFile(buddies[i].image);
        final BitmapDescriptor imageIcon =
            await convertImageFileToBitmapDescriptor(imageAsFile);
       userIdMarkerMap[buddies[i].uid] = imageIcon; 
             
      } else {
        userIdMarkerMap[buddies[i].uid] = BitmapDescriptor.defaultMarker;
      }
    }
    return userIdMarkerMap;
  }

  // Method to create marker-set.
  Future<Set<Marker>> createMarkers(List<Buddy> buddies) async {
    Set<Marker> markers = {};
    Map<String, BitmapDescriptor> icons = await _imageIcon(buddies);
    //await Future.delayed(Duration(seconds: 30));
    for (int i = 0; i < buddies.length; i++) {
      Buddy buddyData = buddies[i];
      if (buddyData.location != null) {
        final Marker marker = Marker(
          markerId: MarkerId(buddyData.uid),
          position:
              LatLng(buddyData.location.latitude, buddyData.location.longitude),
          infoWindow: InfoWindow(
            title: buddyData.name,
            snippet: buddyData.time,
          ),
          icon: icons[buddyData.uid],
        );
        markers.add(marker);
      }
    }
    return markers;
  }

  static Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(
      File imageFile,
      {int size = 130,
      bool addBorder = true,
      Color borderColor = Colors.green,
      double borderSize = 10,
      Color titleColor = Colors.transparent,
      Color titleBackgroundColor = Colors.transparent}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // final Paint paint = Paint()..color;
    // final TextPainter textPainter = TextPainter(
    //   textDirection: TextDirection.ltr,
    // );
    // final double radius = size / 2;

    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        Radius.circular(100)));
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size / 2.toDouble(), size + 20.toDouble(), 10, 10),
        Radius.circular(100)));
    canvas.clipPath(clipPath);

    //paintImage
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    // ui.Codec
    final Codec codec = await instantiateImageCodec(imageUint8List);
    final FrameInfo imageFI = await codec.getNextFrame();

    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    //convert canvas as PNG bytes
    final _image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    // ui.ImageByteFormat
    final data = await _image.toByteData(format: ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }


}
