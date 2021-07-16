import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/auth.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/shared/constant.dart';
import 'package:kinbo/shared/loading.dart';
import 'package:kinbo/views/home/mapview.dart';
import 'package:kinbo/views/profile/upload_photo.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Profile extends StatefulWidget {
  //const SettingsForm({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String _currentName;
  String _currentBio;
  String _image;
  String _imageUrlFromCloud;

  Future<void> uploadImageAndGetUrl(String uid) async {
    if (_image != null) {
      firebase_storage.Reference imageStorage =
          firebase_storage.FirebaseStorage.instance.ref().child('images/$uid');

      await imageStorage.putFile(File(_image));
      print(_image);
      print('File Uploaded');

      String fileUrl = await imageStorage.getDownloadURL();
      print('fileUrl is  ');
      print(fileUrl);
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          _imageUrlFromCloud = fileUrl;
        });
      }
    }
  }

  void imageForm(String img) {
    setState(() => _image = img);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj>(context);

    if (user != null) {
      return StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Edit profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.indigo[300],
                  elevation: 1.0,
                ),

//
// Profile Page Body

                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 60.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
// List of Fiedls

                          children: <Widget>[
                            /// Image field

                            UploadPhoto(userData.image, imageForm),

                            SizedBox(height: 20.0),
// Name field

                            TextFormField(
                              initialValue: userData.name,
                              decoration: textInputDecoration("Name"),
                              validator: (val) =>
                                  val.isEmpty ? ' What is your name ?' : null,
                              onChanged: (val) =>
                                  setState(() => _currentName = val),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),

// Bio field
                            TextFormField(
                              initialValue: userData.bio,
                              decoration: textInputDecoration("Bio"),
                              validator: (val) =>
                                  val.isEmpty ? 'Tell us about you !' : null,
                              onChanged: (val) =>
                                  setState(() => _currentBio = val),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

// Update button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigo[300],
                              ),
                              onPressed: () async {
                                await uploadImageAndGetUrl(user.uid);

                                print('Url found ');
                                print(_imageUrlFromCloud);

                                if (_formKey.currentState.validate()) {
                                  await DatabaseService(uid: user.uid)
                                      .updateUserData(
                                    name: _currentName ?? userData.name,
                                    bio: _currentBio ?? userData.bio,
                                    image: _imageUrlFromCloud ?? userData.image,
                                  );
                                } else {}
                                Navigator.popUntil(
                                    context, ModalRoute.withName('/'));
                              },
                              child: Text(
                                ' Update ',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

// Log out button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.pink[300],
                              ),
                              onPressed: () async {
                                await _auth.signOut();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Sign out',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Loading();
            }
          });
    }
    return Loading();
  }
}
