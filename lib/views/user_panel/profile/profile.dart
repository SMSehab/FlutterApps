import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/auth.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/views/shared/input_decoration.dart';
import 'package:kinbo/views/shared/list_builder.dart';
import 'package:kinbo/views/shared/loading.dart';
import 'package:kinbo/views/user_panel/profile/upload_photo.dart';
import 'package:provider/provider.dart';


// Every user's profile view,
// shows user's profile box,
// list of his follower and following,
// sign-out and update button.


class Profile extends StatefulWidget {
  String uid;
  Profile(this.uid);
  //const SettingsForm({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String _currentName;
  String _currentBio;

  List<UserData> _followers = [];

  @override
  void initState() {
    _getFollowers();
    super.initState();
  }

  //this is one time future method. that's why don't updates like stream.
  Future<void> _getFollowers() async {
    UserData me = await DatabaseService()
        .buddyCollection
        .doc(widget.uid)
        .get()
        .then(DatabaseService().userDataFromSnapshot);
    if (me.friends != null) {
      for (int i = 0; i < me.friends.length; i++) {
        String id = me.friends[i];
        _followers.add(await DatabaseService()
            .buddyCollection
            .doc(id)
            .get()
            .then(DatabaseService().userDataFromSnapshot));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj>(context);
    final _following = Provider.of<List<Friend>>(context) ?? [];
    final userData = Provider.of<UserData>(context);

    if (userData != null) {
      return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 5, left: 5),
                        height: 230.00,
                        width: 340.00,
                        margin: EdgeInsets.only(top: 30, left: 20),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(Constant.padding),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 10),
                                  blurRadius: 10),
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // List of Fiedls

                          children: <Widget>[
                            Container(
                              height: 90,
                              padding: EdgeInsets.only(
                                left: 100.00,
                              ),
                              child: Center(
                                child: TextFormField(
                                  inputFormatters: <TextInputFormatter>[
                                    LowerCaseTextFormatter(),
                                    //FilteringTextInputFormatter.deny(RegExp("[A-Z]")),
                                  ],
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  textAlign: TextAlign.center,
                                  initialValue: userData.name,
                                  decoration: textInputDecoration("name"),
                                  validator: (val) =>
                                      val.length > 2 && val.length < 26
                                          ? null
                                          : ' length must be 3-25 ',
                                  onChanged: (val) =>
                                      setState(() => _currentName = val),
                                  autovalidateMode: AutovalidateMode.always,
                                  minLines: 2,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              height: 110,
                              child: TextFormField(
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 14),
                                ),
                                //textAlign: TextAlign.center,
                                initialValue: userData.bio,
                                decoration: textInputDecoration("bio"),
                                validator: (val) => val.isEmpty
                                    ? 'Tell us about you !'
                                    : val.length > 500
                                        ? ' max length is 500 '
                                        : null,
                                onChanged: (val) =>
                                    setState(() => _currentBio = val),

                                //expands: true,
                                maxLines: 8,
                                minLines: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          child: UploadPhoto(userData.image, widget.uid)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.00,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: 110.00,
                    // ),
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
                    SizedBox(
                      width: 30.00,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[300],
                      ),
                      onPressed: () async {
                        //await uploadImageAndGetUrl(user.uid);
                        // print('Url found ');
                        // print(_imageUrlFromCloud);

                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            name: _currentName ?? userData.name,
                            bio: _currentBio ?? userData.bio,
                            //image: _imageUrlFromCloud ?? userData.image,
                          );
                        } else {}
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      child: Text(
                        ' Update ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                headline('Following'),

                SizedBox(
                  height: 2.0,
                ), 
                ListBuilder(
                  _following,
                  user.uid,
                  true,
                  physics: NeverScrollableScrollPhysics(),
                ),
                SizedBox(
                  height: 5.0,
                ),
                headline('Follower'),

                SizedBox(
                  height: 2.0,
                ),
                ListBuilder(
                  _followers,
                  user.uid,
                  false,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Loading();
    }
  }

  Widget headline(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13.00, vertical: 8.00),
          margin: EdgeInsets.only(left: 13.00),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  spreadRadius: 1,
                  //blurRadius: 10
                ),
              ]),
          child: Text(text,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ))),
    );
  }
}

class Constant {
  Constant._();
  static const double padding = 20;
  static const double avatarRadius = 60;
}
