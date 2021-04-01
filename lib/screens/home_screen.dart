import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/screens/sign%20up/signup_welcome_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to Loopez'),
              ElevatedButton(
                onPressed: () {
                  _logout(context);
                },
                child: Text('Logout'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    FirebaseAuth.instance
        .signOut()
        .then(
          (value) => () {
            print('Logout Completed');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
        )
        .catchError(
      (onError) {
        print('Error Loggin out: ${onError}');
      },
    );
  }
}
