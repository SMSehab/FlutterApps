import 'package:flutter/material.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/auth.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/views/profile/profile.dart';
import 'package:provider/provider.dart';

class UserPanel extends StatefulWidget {
  // final String uid;

  //UserPanel(this.uid);
  //const UserPanel({ Key? key }) : super(key: key);

  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<UserObj>.value(
          initialData: UserObj(), 
          value: AuthService().user),
      StreamProvider<List<Buddy>>.value(
          initialData: [], value: DatabaseService().buddies),
      //StreamProvider<LocationData>.value(value: LocationService().getLocation),
      // StreamProvider<UserData>.value(
      //     value: DatabaseService(uid: widget.uid).userData),
    ], child: Profile());
  }
}
