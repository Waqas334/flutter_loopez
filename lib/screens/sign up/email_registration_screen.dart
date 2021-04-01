import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/components/buttons/rounded_filled_text_button.dart';
import 'package:flutter_loopez/components/buttons/rounded_stroke_textfield.dart';
import 'package:flutter_loopez/screens/home_screen.dart';
import 'package:flutter_loopez/screens/sign%20up/email_login_screen.dart';
import 'package:flutter_loopez/screens/temp_bottom_navigation.dart';
import 'package:flutter_loopez/utils.dart';

import '../../constants.dart';

class EmailRegistrationScreen extends StatefulWidget {
  static String name = '/emailRegistration';

  @override
  _EmailRegistrationScreenState createState() =>
      _EmailRegistrationScreenState();
}

class _EmailRegistrationScreenState extends State<EmailRegistrationScreen> {
  var formKey = GlobalKey<FormState>();
  var passwordFieldController = TextEditingController();

  String email;

  String password;

  String generalErrorMessage = '';

  bool buttonInProgress = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('< Back'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: kTextStyleHeadline,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      Text(
                        'Enter your Email and Password to register',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
//                      autovalidateMode: AutovalidateMode.always,
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            String emailValidationResponse =
                                isValidEmail(value);
                            if (emailValidationResponse != 'YES') {
                              return emailValidationResponse;
                            }
                            return null;
                          },
                          onSaved: (value) => email = value,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordFieldController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Password can\'t be empty';
                            }

                            if (value.length < 6) {
                              return 'Password must be 6 character long';
                            }

                            return null;
                          },
                          onSaved: (value) => password = value,
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Repeat Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (passwordFieldController.text != value) {
                              return 'Repeat Password doesn\'t match';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: _loginExistingUserClicked,
                    child: Container(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Already have account? ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                              text: 'Login Now',
                              style: kTextStyleClickable,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(generalErrorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red)),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
            RoundTextButton(
              label: 'Register',
              onClick: _registerUser,
              inProgress: buttonInProgress,
            ),
          ],
        ),
      ),
    );
  }

  _loginExistingUserClicked() {
    Navigator.pop(context);
  }

  _registerUser() {
    if (buttonInProgress) return;

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _loginWithEmailAndPassword(email: email, password: password);
    }
  }

  _loginWithEmailAndPassword({String email, String password}) async {
    setState(() {
      buttonInProgress = true;
    });
    var authInstance = FirebaseAuth.instance;

    try {
      await authInstance.createUserWithEmailAndPassword(
          email: email, password: password);
      print('Current User: ${authInstance.currentUser.toString()}');
      buttonInProgress = false;

      Navigator.pushNamedAndRemoveUntil(
          context, LandingPage.name, (route) => false);
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth exception: ${e.message}');
      setState(() {
        generalErrorMessage = e.message;
        buttonInProgress = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        generalErrorMessage = e.toString();
        print(e);
        buttonInProgress = false;
      });
    }

    return;
  }
}
