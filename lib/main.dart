import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_loopez/components/body.dart';
import 'package:flutter_loopez/constants.dart';
import 'package:flutter_loopez/screens/home_screen.dart';
import 'package:flutter_loopez/screens/sign%20up/email_login_screen.dart';
import 'package:flutter_loopez/screens/sign%20up/email_registration_screen.dart';
import 'package:flutter_loopez/screens/sign%20up/signup_welcome_screen.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_loopez/screens/temp_bottom_navigation.dart';
import 'package:flutter_loopez/screens/user_setting_screen.dart';
import 'package:flutter_loopez/components/progress_indicator.dart'
    as COMPONENETS;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyNewApp());
//  runApp(UserSetting());
}

class MyNewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ChooseLoginMethodScreen.name,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        EmailRegistrationScreen.name: (context) => EmailRegistrationScreen(),
        EmailPasswordLogin.name: (context) => EmailPasswordLogin(),
        LandingPage.name: (context) => LandingPage(),
        UserSetting.name: (context) => UserSetting(),
        ChooseLoginMethodScreen.name: (context) => ChooseLoginMethodScreen(),
        SignUpScreen.name: (context) => SignUpScreen(),
      },
    );
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
