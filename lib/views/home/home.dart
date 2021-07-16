import 'package:flutter/material.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/views/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:kinbo/services/database.dart';
import 'buddy_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<UserObj>(context);

    // return StreamProvider<UserData>.value(
    //   value: DatabaseService(uid: user.uid).userData,
    //   child:
          // StreamProvider<List<Buddy>>.value(
          //   value: DatabaseService().buddies,
          //   child:
          return
          Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Status Feed"),
          backgroundColor: Colors.brown[500],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('me'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Profile(),
                    ),
                  );
                })
          ],
        ),
        body: Profile(),
      //),
    ); //BuddyList()));
  }
}
