import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';

class DatabaseService {
  final String uid;
  String query;

  DatabaseService({this.uid, this.query});

  final CollectionReference buddyCollection =
      FirebaseFirestore.instance.collection('buddies');

  Future updateUserData(
      {String uuid,
      String name,
      String bio,
      GeoPoint location,
      String time,
      List friends,
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
      List friends,
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
// Create Buddy model locally from snapshot.
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

  // Stream to notify only search user update.
  Stream<List<Buddy>> get buddySearch {
    return buddyCollection
        //.orderBy('bio')
        .where('name', isEqualTo: query ?? "")
        .snapshots()
        .map(_buddyListFromSnapshot);
  }

  // Stream to notify for ALL users update.
  Stream<List<Buddy>> get buddies {
    return buddyCollection.snapshots().map(_buddyListFromSnapshot);
  }

//
//-------------------------------------------------------------
// Create UserData model locally
  UserData userDataFromSnapshot(DocumentSnapshot doc) {
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

  // Stream for specific user data.
  Stream<UserData> get userData {
    return buddyCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }

//
//--------------------------------------------------------------------
// Create Friend model locally from snapshot.
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

  // Stream to notify for ALL friends update.
  Stream<List<Friend>> get friends {
    return buddyCollection
        .where('friends', arrayContainsAny: [this.uid])
        .snapshots()
        .map(_friendListFromSnapshot);
  }

//
//----------------------------------------------------------------------
// Future method to initiate friends' marker icons.
  Future<List<Friend>> buddyImages() {
    return buddyCollection
        .where('friends', arrayContainsAny: [this.uid])
        .get()
        .then(
            _friendListFromSnapshot);
  }
}
