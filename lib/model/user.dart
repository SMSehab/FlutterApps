import 'package:cloud_firestore/cloud_firestore.dart';

class UserObj {
  final String uid;

  UserObj({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String bio;
  final GeoPoint location;
  final String image;
  final List friends;
  final String time;

  UserData({
    this.uid,
    this.name,
    this.bio,
    this.location,
    this.image,
    this.friends,
    this.time,
  });
}
