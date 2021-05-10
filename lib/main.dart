import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_loopez/screens/sell2/main_categories.dart';
import 'package:flutter_loopez/screens/sell2/sub_categories.dart';
import 'package:flutter_loopez/screens/sign%20up/email_login_screen.dart';
import 'package:flutter_loopez/screens/sign%20up/email_registration_screen.dart';
import 'package:flutter_loopez/screens/sign%20up/signup_welcome_screen.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_loopez/screens/landing_screen.dart';
import 'package:flutter_loopez/screens/user_setting_screen.dart';
import 'package:flutter_loopez/components/progress_indicator.dart'
    as COMPONENETS;
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart' as LOCATION;

import 'model/ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyNewApp());
//  runApp(UserSetting());
}

class MyNewApp extends StatefulWidget {
  @override
  _MyNewAppState createState() => _MyNewAppState();
}

class _MyNewAppState extends State<MyNewApp> {
  Ads ads;
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  bool isUpdated = false;

  @override
  Widget build(BuildContext context) {
    if (!isUpdated) {
      return MaterialApp(
          home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    } else
      return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: ads,
            ),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              splashColor: Colors.grey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: TextTheme(
                button: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            routes: {
              '/': (context) => ChooseLoginMethodScreen(),
              EmailRegistrationScreen.name: (context) =>
                  EmailRegistrationScreen(),
              EmailPasswordLogin.name: (context) => EmailPasswordLogin(),
              LandingPage.name: (context) => LandingPage(),
              UserSetting.name: (context) => UserSetting(),
              ChooseLoginMethodScreen.name: (context) =>
                  ChooseLoginMethodScreen(),
              SignUpScreen.name: (context) => SignUpScreen(),
              // MainCatogriesPage.routeName: (context) => MainCatogriesPage(),
              // SubCategoriesPage.routeName: (context) => SubCategoriesPage(),
              // PostAdStep1.routeName: (context) => PostAdStep1(),
              // PostAdFinalStep.routeName: (context) => PostAdFinalStep(),
            },
          ));
  }

  void getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    LOCATION.PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print('service is not enabled, requesting one');
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('service is not enabled again, returning');
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == LOCATION.PermissionStatus.denied) {
      print('Permission are denied, requesing one');
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != LOCATION.PermissionStatus.granted) {
        print('permission is not granted again, returning');
        return;
      }
    }

    _locationData = await location.getLocation();

    Coordinates coordinates =
        Coordinates(_locationData.latitude, _locationData.longitude);
    List<Address> addresses;
    try {
      addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
    } catch (e) {
      print('Soemthing went wrong while getting the address: $e');
    }

    setState(() {
      print(
          'Fetched address: \nAdmin Area: ${addresses.first.adminArea}\tCity: ${addresses.first.locality}');
      ads = Ads(addresses.first);
      isUpdated = true;
    });
  }
}

class ChooseLoginMethodScreen extends StatefulWidget {
  // This widget is the root of your application.
  static String name = '/';

  @override
  _ChooseLoginMethodScreenState createState() =>
      _ChooseLoginMethodScreenState();
}

class _ChooseLoginMethodScreenState extends State<ChooseLoginMethodScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (Firebase.apps.length != 0) {
      return MainClass();
    } else
      return FutureBuilder(
        // This future checks if the firebase is initialized or not
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          print('Future builder for Firebase Initialization was called again');
          if (snapshot.hasError) {
            print('Something went wrong while initializing the Firebase');
            return COMPONENETS.ProgressIndicator(
              message: snapshot.error ?? 'Something went wrong',
              inProgress: false,
              onRetry: () {
                setState(() {});
              },
            );
          } else {
            print('There is no error with Firebase Initialization');
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            print('Firebase Initializing connection is waiting or null');
            return COMPONENETS.ProgressIndicator(
              inProgress: true,
            );
          } else {
            print('Firebase Initializing connection established');
          }
          return MainClass();
        },
      );
  }
}

class MainClass extends StatefulWidget {
  @override
  _MainClassState createState() => _MainClassState();
}

class _MainClassState extends State<MainClass> {
  @override
  Widget build(BuildContext context) {
//    return (true)
    return (Firebase.apps.length == 0)
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: StreamBuilder<User>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
//                if (true) {
                if (snapshot.hasError) {
                  return COMPONENETS.ProgressIndicator(
                    inProgress: false,
                    message: snapshot.error ?? 'Something went wrong',
                    onRetry: () {
                      setState(() {});
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return COMPONENETS.ProgressIndicator();
                } else {
                  print(
                      'Snapshot is not null and here is the message: ${snapshot.data}');
                  if (snapshot.data == null) {
//                          return UserSetting();
                    return SignUpScreen();
                  } else {
//                          return UserSetting();
                    return LandingPage();
                  }
                }
              },
            ),
          );
  }
}
