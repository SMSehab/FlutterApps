import 'package:flutter/material.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/auth.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/views/shared/loading.dart';
import 'package:kinbo/views/user_panel/people/find_friends.dart';
import 'package:kinbo/views/user_panel/profile/profile.dart';
import 'package:provider/provider.dart';


// two tabs to switch between profile and find friend. 

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
    return MultiProvider(
      providers: [
        // Providers without UID needed.
        StreamProvider<UserObj>.value(
            initialData: UserObj(), value: AuthService().user),
        // StreamProvider<List<Buddy>>.value(
        //     initialData: [], value: DatabaseService().buddies),
        //StreamProvider<LocationData>.value(value: LocationService().getLocation),
      ],
      child: Builder(
        builder: (context) {
          final user = Provider.of<UserObj>(context);
          if (user != null) {
            return MultiProvider(
              providers: [
                // Providers with UID needed.
                StreamProvider<List<Friend>>.value(
                    initialData: null,
                    value: DatabaseService(uid: user.uid).friends),
                StreamProvider<UserData>.value(
                    initialData: null,
                    value: DatabaseService(uid: user.uid).userData),
              ],
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    flexibleSpace: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TabBar(
                          tabs: [
                            Tab(icon: Icon(Icons.person)),
                            Tab(icon: Icon(Icons.person_add)),
                          ],
                          indicatorColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                        ),
                      ],
                    ),
                    backgroundColor: Colors.indigo[300],
                  ),
                  // title: const Text('Tabs Demo'),

                  body: TabBarView(
                    children: [
                      Profile(user.uid),
                      FindFriends(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
