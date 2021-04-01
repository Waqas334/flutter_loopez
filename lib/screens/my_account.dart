import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/constants.dart';
import 'package:flutter_loopez/screens/sign%20up/signup_welcome_screen.dart';
import 'package:flutter_loopez/screens/user_setting_screen.dart';

import '../main.dart';

class MyAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: currentUser.isAnonymous
                        ? AssetImage('assets/user/man.png')
                        : currentUser.photoURL != null
                            ? NetworkImage(currentUser.photoURL)
                            : AssetImage('assets/user/man.png'),
                  ),
                ),
                Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (currentUser.isAnonymous)
                              ? 'LOG IN'
                              : (currentUser.displayName == null ||
                                      currentUser.displayName.length == 0)
                                  ? 'DISPLAY NAME HERE'
                                  : currentUser.displayName,
                          style: kTextStyleHeadline,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (currentUser.isAnonymous)
                              return _logInClicked(context);
                            return _viewAndEditProfileClicked(context);
                          },
                          child: Text(
                            (currentUser.isAnonymous)
                                ? 'Log in to your account'
                                : 'View and edit profile',
                            style: kTextStyleClickable,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _viewAndEditProfileClicked(BuildContext context) {
    Navigator.pushNamed(context, UserSetting.name);
  }

  void _logInClicked(context) {
    Navigator.pushNamed(context, SignUpScreen.name);
  }
}
