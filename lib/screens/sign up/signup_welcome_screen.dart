import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_loopez/components/buttons/rounded_filled_button.dart';
import 'package:flutter_loopez/components/buttons/rounded_stroke_button.dart';
import 'package:flutter_loopez/screens/sign%20up/phone_number_screen.dart';
import 'package:flutter_loopez/screens/landing_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'email_login_screen.dart';

class SignUpScreen extends StatelessWidget {
  static String name = '/signUpScreen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => _skipClicked(context),
                child: Container(
                  // height: size.height * 0.09,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//          color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: Text('Skip >>'),
                ),
              ),
            ],
          ),
          Container(
            height: size.height * 0.20,
//          color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome to'),
                Text(
                  'LoopeZ',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  'The trusted community of buyers and sellers',
                )
              ],
            ),
          ),
          Container(
            height: size.height * 0.55,
            width: size.width * 0.70,
//          color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedStrokeButton(
                  label: 'Continue with Phone Number',
                  icon: Icon(Icons.phone),
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpWithPhoneNumber()),
                    );
                  },
                ),
                RoundedStrokeButton(
                  label: 'Continue with Google',
                  image: SvgPicture.asset(
                    "assets/icons/google-plus.svg",
                  ),
                  onClick: () => _signInWithGoogle(context),
                ),
                RoundedStrokeButton(
                  label: 'Continue with Facebook',
                  image: SvgPicture.asset("assets/icons/facebook.svg"),
                  onClick: () => _singInWithFacebook(context),
                ),
                RoundedStrokeButton(
                  label: 'Continue with Apple',
                  image: SvgPicture.asset("assets/icons/apple.svg"),
                  onClick: () => _singInWithFacebook(context),
                ),
                RoundedFilledButton(
                  label: 'Continue with Email',
//                image: SvgPicture.asset("assets/icons/facebook.svg"),
                  icon: Icons.email,
                  onButtonClick: () {
                    Navigator.pushNamed(context, EmailPasswordLogin.name);
                  },
                ),
              ],
            ),
          ),
          Container(
            height: size.height * 0.10,
            alignment: Alignment.bottomCenter,
            child: Text(
              'If you continue, you are accepting\nLoopez Terms and Privacy Policy',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
//      body: Body(),
    ));
  }

  void _skipClicked(context) async {
    //There are some cases where users is already logged in anonymously and yet
    //the skip button was clicked.
    //So we need to manage both

    if (FirebaseAuth.instance.currentUser == null) {
      //No one is logged
      try {
        await FirebaseAuth.instance.signInAnonymously();
        Navigator.pushNamed(context, LandingPage.name);
      } catch (e) {
        print('Something went wrong when signing in anonymously: ${e}');
      }
    } else {
      Navigator.pop(context);
    }
  }

  _singInWithFacebook(BuildContext context) async {
    FacebookLoginResult result;
    String profilePhotoUrl;
    try {
      result = await FacebookLogin().logIn(['email']);
      print(
          'Facebook access token: ${result.accessToken}\nFacebook status: ${result.status}\n Error message: ${result.errorMessage}');

      var graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(500).height(500)&access_token=${result.accessToken.token}'));

      var profile = jsonDecode(graphResponse.body);
      profilePhotoUrl = profile['picture']['data']['url'];
      print('Profile Picture: $profilePhotoUrl');
//      print(profile.toString());
    } catch (e) {
      print('Something went wrong while logging into Facebook: $e');
    }

    try {
      FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      if (profilePhotoUrl != null) {
        User currentUser = FirebaseAuth.instance.currentUser;
        currentUser.updateProfile(photoURL: profilePhotoUrl);
      }
      Navigator.pushNamedAndRemoveUntil(
          context, LandingPage.name, (route) => false);
    } catch (e) {
      print('Something went wrong when logging into Firebase: $e');
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    print('Sign In with Google clicked');
    GoogleSignInAccount googleSignIn;
    try {
      googleSignIn = await GoogleSignIn().signIn();
      print('Sign in with Google Completed');
    } catch (e) {
      print('Something went wrong with Google Sign In');
    }

    GoogleSignInAuthentication googleSignInAuthentication;
    try {
      googleSignInAuthentication = await googleSignIn.authentication;
      print('Got authentication');
      OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, LandingPage.name, (route) => false);
    } catch (e) {
      print('Something went wrong while getting the Google authentication: $e');
    }
  }
}
