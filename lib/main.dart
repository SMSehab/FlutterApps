import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/auth.dart';
import 'package:kinbo/services/location.dart';
import 'package:kinbo/views/user_panel/user_panel.dart';
import 'package:kinbo/views/wrapper.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(App());
  } catch (e) {
    print("Firebase Initialization Error: $e");
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserObj?>.value(
            initialData: UserObj(uid: ' '), value: AuthService().user),
        StreamProvider<LocationData?>.value(
            initialData: null, value: LocationService().getLocation),
        StreamProvider<bool?>.value(
            initialData: null,
            value: LocationService().locationEnabledStream),
        StreamProvider<perm.PermissionStatus?>.value(
            initialData: null,
            value: LocationService().permissionGrantedStream),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          title: 'Locate Buddy',
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
