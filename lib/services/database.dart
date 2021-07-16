import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference buddyCollection =
      FirebaseFirestore.instance.collection('buddies');

  Future updateUserData(
      {String uuid,
      String name,
      String bio,
      GeoPoint location,
      String time,
      List<String> friends,
      String image}) async {
    return await buddyCollection.doc(uid).update({
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (location != null) 'location': location,
      if (time != null) 'time': time,
      if (image != null) 'image': image,
      if (uuid != null) 'uid': uuid,
      if (friends != null) 'friends': friends,
    });
  }

  Future setNewUserData(
      {String uuid,
      String name,
      String bio,
      GeoPoint location,
      String time,
      List<String> friends,
      String image}) async {
    return await buddyCollection.doc(uid).set({
      'name': name,
      'bio': bio,
      'location': location,
      'time': time,
      'image': image,
      'uid': uuid,
      'friends': friends,
    });
  }

//
//--------------------------------------------------------------------
//
  // creating buddy object from snapshot.
  List<Buddy> _buddyListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Buddy(
              uid: doc.id,
              name: doc['name'] ?? null,
              bio: doc['bio'] ?? null,
              location: doc['location'] ?? null,
              time: doc['time'] ?? null,
              image: doc['image'] ?? null,
              friends: doc['friends']) ??
          null;
    }).toList();
  }

  // Stream to notify for user update.
  Stream<List<Buddy>> get buddies {
    return buddyCollection.snapshots().map(_buddyListFromSnapshot);
  }

  // Method to initiate marker icons.
  Future<List<Buddy>> buddyImages() {
    return buddyCollection.get().then(
        _buddyListFromSnapshot); // (value) => _buddyListFromSnapshot(value));
  }

//
//-------------------------------------------------------------
//
  UserData _userDataFromSnapshot(DocumentSnapshot doc) {
    if (doc != null) {
      return UserData(
              uid: uid,
              name: doc['name'] ?? null,
              bio: doc['bio'] ?? null,
              location: doc['location'] ?? null,
              image: doc['image'] ?? null,
              time: doc['time'] ?? null,
              friends: doc['friends']) ??
          null;
    } else {
      return null;
    }
  }

  // Stream to populate user previous data.
  Stream<UserData> get userData {
    return buddyCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

//
//--------------------------------------------------------------------
//
//  creating friend object from snapshot.
  List<Friend> _friendListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Friend(
              uid: doc.id,
              name: doc['name'] ?? null,
              bio: doc['bio'] ?? null,
              location: doc['location'] ?? null,
              time: doc['time'] ?? null,
              image: doc['image'] ?? null,
              friends: doc['friends']) ??
          null;
    }).toList();
  }

  // Stream to update friend list.
  Stream<List<Friend>> get friends {
    return buddyCollection
        .where('friends', arrayContainsAny: ['uid'])
        .snapshots()
        .map(_friendListFromSnapshot);
  }
}
