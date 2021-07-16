import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Buddy {
  final String uid; 
  final String name;
  final String bio;
  final GeoPoint location;
  final String image;
  final List<String> friends;
  final String time;

  Buddy({
    this.uid,
    this.name,
    this.bio,
    this.location,
    this.image,
    this.friends,
    this.time,
  });
}

class Friend {
  final String uid; 
  final String name;
  final String bio;
  final GeoPoint location;
  final String image;
  final List<String> friends;
  final String time;

  Friend({
    this.uid,
    this.name,
    this.bio,
    this.location,
    this.image,
    this.friends,
    this.time,
  });
}
