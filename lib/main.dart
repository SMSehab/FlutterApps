import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/location_data.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/auth.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/services/location.dart';
import 'package:kinbo/views/user_panel/user_panel.dart';
import 'package:kinbo/views/wrapper.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatelessWidget {
  //const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  Streams:
    //    UserObj, BuddyList, LocationData,
    //    LocationEnabled, LocationPermission,
    LocationData l;
    return MultiProvider(
      providers: [
        StreamProvider<UserObj>.value(
            initialData: null,//UserObj(), 
            value: AuthService().user),
        // StreamProvider<List<Buddy>>.value(
        //     initialData: null, value: DatabaseService().buddies),
        StreamProvider<LocationData>.value(
            initialData: null, 
            value: LocationService().getLocation),
        StreamProvider<bool>.value(
            initialData: null, 
            value: LocationService().locationEnabledStream),
        StreamProvider<PermissionStatus>.value(
            initialData: null,
            value: LocationService().permissionGrantedStream),
        // StreamProvider<UserData>.value(
        //     value: DatabaseService(uid: (Provider.of<UserObj>(context).uid))
        //         .userData),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // transparent status bar
          systemNavigationBarColor: Colors.white, // navigation bar color
          statusBarIconBrightness: Brightness.dark, // status bar icons' color
          systemNavigationBarIconBrightness:
              Brightness.dark, //navigation bar icons' color
        ),
        child: MaterialApp(
          title: 'koi mama?',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => Wrapper(),
            '/userPanel': (context) => UserPanel(),
          },
        ),
      ),
    );
  }
}