import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kinbo/model/buddy.dart';

class CreateMarkers {
  // Method to convert image into marker-icon
  Future<Map<String, BitmapDescriptor>> imageIcon(List<Friend> buddies) async {
    Map<String, BitmapDescriptor> userIdMarkerMap = {};

    for (Friend buddy in buddies) {
      if (buddy.image != null && buddy.image!.isNotEmpty) {
        try {
          final File imageAsFile =
          await DefaultCacheManager().getSingleFile(buddy.image!);
          final BitmapDescriptor imageIcon =
          await _createCustomMarkerIcon(imageAsFile);
          userIdMarkerMap[buddy.uid ?? "unknown"] = imageIcon;
        } catch (e) {
          print("Error loading image for ${buddy.uid}: $e");
          userIdMarkerMap[buddy.uid ?? "unknown"] =
              BitmapDescriptor.defaultMarker;
        }
      } else {
        userIdMarkerMap[buddy.uid ?? "unknown"] =
            BitmapDescriptor.defaultMarker;
      }
    }
    return userIdMarkerMap;
  }

  // Method to create markers
  Set<Marker> createMarkers(
      List<Friend> buddies, Map<String, BitmapDescriptor> icons) {
    Set<Marker> markers = {};

    for (Friend buddyData in buddies) {
      if (buddyData.uid != null && buddyData.location != null) {
        final Marker marker = Marker(
          markerId: MarkerId(buddyData.uid!),
          position:
          LatLng(buddyData.location!.latitude, buddyData.location!.longitude),
          infoWindow: InfoWindow(
            title: buddyData.name ?? "Unknown",
            snippet: buddyData.time != null
                ? "Last active: ${buddyData.time}"
                : "Last active: N/A",
          ),
          icon: (icons.containsKey(buddyData.uid) && icons[buddyData.uid] != null)
              ? icons[buddyData.uid]!
              : BitmapDescriptor.defaultMarker,
        );
        markers.add(marker);
      }
    }
    return markers;
  }

  // Method to create custom marker icon
  Future<BitmapDescriptor> _createCustomMarkerIcon(File imageFile) async {
    const int targetWidth = 40;
    const int targetHeight = 50;
    const double circleRadius = targetWidth / 2;
    const double triangleHeight = 20;
    const double triangleWidth = 35;
    const double borderWidth = 6;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Draw the downward-pointing triangle (simplified marker base)
    final Path trianglePath = Path()
      ..moveTo(circleRadius - (triangleWidth / 2), targetHeight - triangleHeight)
      ..lineTo(circleRadius + (triangleWidth / 2), targetHeight - triangleHeight)
      ..lineTo(circleRadius, targetHeight.toDouble())
      ..close();

    canvas.drawPath(trianglePath, Paint()..color = Colors.red); // Red marker base

    // Draw the circular profile picture with a red border
    final Path circlePath = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(circleRadius, circleRadius), radius: circleRadius));

    // Load the image
    final Uint8List imageBytes = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageBytes,
      targetWidth: targetWidth,
      targetHeight: targetWidth,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    // Clip the canvas to the circular path (for the image)
    canvas.clipPath(circlePath);

    // Draw the image onto the circular path
    canvas.drawImage(image, Offset.zero, Paint());

    // Draw the red border
    canvas.drawPath(
        circlePath,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth);

    // Convert the canvas to an image
    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(
      targetWidth,
      targetHeight,
    );
    final ByteData? byteData =
    await markerImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("Failed to convert image to byte data.");
    }

    return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
  }
}
