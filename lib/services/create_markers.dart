import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kinbo/model/buddy.dart';
//import 'package:image/image.dart' as Images;

class CreateMarkers {
  // Method to convert image into marker-icon
  Future<Map<String, BitmapDescriptor>> imageIcon(List<Friend> buddies) async {
    Map<String, BitmapDescriptor> userIdMarkerMap = {};

    for (int i = 0; i < buddies.length; i++) {
      if (buddies[i].image != null) {
        final File imageAsFile =
            await DefaultCacheManager().getSingleFile(buddies[i].image);
        final BitmapDescriptor imageIcon = //await paint(imageAsFile);
            await convertImageFileToBitmapDescriptor(imageAsFile);
        userIdMarkerMap[buddies[i].uid] = imageIcon;
      } else {
        userIdMarkerMap[buddies[i].uid] = BitmapDescriptor.defaultMarker;
      }
    }
    return userIdMarkerMap;
  }

  // Method to create marker-set.
  Set<Marker> createMarkers(
      List<Friend> buddies, Map<String, BitmapDescriptor> icons) {
    Set<Marker> markers = {};
    //Iterate the frndlist and 
    //set image as marker if has one, 
    //otherwise set default marker
    for (int i = 0; (i < buddies.length); i++) {
      Friend buddyData = buddies[i];
      if (buddyData.location != null) {
        final Marker marker = Marker(
          markerId: MarkerId(buddyData.uid),
          position:
              LatLng(buddyData.location.latitude, buddyData.location.longitude),
          infoWindow: InfoWindow(
            title: buddyData.name,
            snippet: "Last active: " + buddyData.time,
          ),
          icon: (icons.isNotEmpty && icons[buddyData.uid] != null)
              ? icons[buddyData.uid]
              : BitmapDescriptor.defaultMarker,
        );
        markers.add(marker);
      }
    }
    return markers;
  }
  // helper function to customize image. 
  static Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(
      File imageFile,
      {int size = 130,
      bool addBorder = true,
      Color borderColor = Colors.green,
      double borderSize = 10,
      Color titleColor = Colors.transparent,
      Color titleBackgroundColor = Colors.transparent}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    // final Paint paint = Paint()..color;
    // final TextPainter textPainter = TextPainter(
    //   textDirection: TextDirection.ltr,
    // );
    // final double radius = size / 2;
    // ----------------------------------------------------
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        Radius.circular(100)));

    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size / 2.toDouble(), size + 20.toDouble(), 10, 10),
        Radius.circular(100)));
    //-------------------------------------------------------
    canvas.clipPath(clipPath);

    //paintImage
    final Uint8List imageUint8List = await imageFile.readAsBytes();

    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();

    paintImage(
        fit: BoxFit.cover,
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    //convert canvas as PNG bytes
    final _image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }


  // helper function to make custom marker
  // Future<BitmapDescriptor> paint(File file) async {
  //   Size size = Size(500, 500);
  //   final center = Offset(50, 50);
  //   final radius = min(size.width, size.height) / 8;
  //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //   final bytes = new Uint8List.fromList(await file.readAsBytes());
  //   final Completer<ui.Image> completer = new Completer();

  //   ui.Image image;
  //   // ui.decodeImageFromList(bytes, (ui.Image img) {
  //   //   image = img;
  //   // });
  //   ui.decodeImageFromList(bytes, (ui.Image img) {
  //     return completer.complete(img);
  //   });
  //   image = await completer.future;

  //   // The circle should be paint before or it will be hidden by the path
  //   Paint paintCircle = Paint()..color = Colors.black;
  //   Paint paintBorder = Paint()
  //     ..color = Colors.white
  //     ..strokeWidth = size.width / 36
  //     ..style = PaintingStyle.stroke;
  //   canvas.drawCircle(center, radius, paintCircle);
  //   canvas.drawCircle(center, radius, paintBorder);

  //   double drawImageWidth = 0;
  //   double drawImageHeight = -size.height * 0.8;

  //   Path path = Path()
  //     ..addOval(Rect.fromLTWH(drawImageWidth, drawImageHeight,
  //         image.width.toDouble(), image.height.toDouble()));

  //   canvas.clipPath(path);

  //   canvas.drawImage(
  //       image, new Offset(drawImageWidth, drawImageHeight), new Paint());

  //   final _image = await pictureRecorder.endRecording().toImage(
  //       300, 300); //(image.width.toInt(), (image.height * 1.1).toInt());
  //   // ui.ImageByteFormat
  //   final data = await _image.toByteData(format: ui.ImageByteFormat.png);

  //   //convert PNG bytes as BitmapDescriptor
  //   return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  // }
}
