import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/components/buttons/progress_indicating_button.dart';
import 'package:flutter_loopez/components/buttons/rounded_filled_text_button.dart';
import 'package:flutter_loopez/components/buttons/rounded_stroke_textfield.dart';
import 'package:flutter_loopez/constants.dart';
import 'package:flutter_loopez/screens/home_screen.dart';
import 'package:flutter_loopez/screens/sign%20up/email_registration_screen.dart';
import 'package:flutter_loopez/screens/temp_bottom_navigation.dart';

import '../../utils.dart';

class EmailPasswordLogin extends StatefulWidget {
  static String name = '/emailLogin';

  @override
  _EmailPasswordLogin createState() => _EmailPasswordLogin();
}

class _EmailPasswordLogin extends State<EmailPasswordLogin> {
  String email;

  String password;

  String generalErrorMessage = '';

  var formState = GlobalKey<FormState>();
  var responsiveButtonState = GlobalKey<ProgressIndicatingButtonState>();

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
                    'Welcome Back',
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
                        'Enter your Email and Password to Login',
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
                    key: formState,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)))),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            String emailValidationResponse =
                                isValidEmail(value);
                            if (emailValidationResponse != 'YES') {
                              return emailValidationResponse;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length <= 0) {
                              return 'Password can\'t be null';
                            } else if (value.length < 6) {
                              return 'Password must be 6 digits long';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            password = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: _registerNewUserClicked,
                    child: Container(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Need account? ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                              text: 'Register Now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: () => _forgotPassword(context),
                      child: Text(
                        'Forgot Password?',
                        style: kTextStyleClickable,
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
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ProgressIndicatingButton(
                  key: responsiveButtonState,
                  onTap: _loginUser,
                  title: 'Log In',
                )),
//            RoundTextButton(
//              label: 'Login',
//              onClick: _loginUser,
//              inProgress: buttonInProgress,
//            ),
          ],
        ),
      ),
    );
  }

  _forgotPassword(context) async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          print('Builder method of showModalBottomSheet was clicked');
          String email;
          String emailErrorMessage;
          return ForgotPasswordBottomSheet();
        });
  }

  _registerNewUserClicked() {
    Navigator.pushNamed(context, EmailRegistrationScreen.name);
  }

  _loginUser() {
    if (responsiveButtonState.currentState.buttonState ==
            ButtonState.PROGRESS ||
        responsiveButtonState.currentState.buttonState == ButtonState.DONE)
      return;

    if (formState.currentState.validate()) {
      //Everything is valid
      formState.currentState.save();
      print('We got email: $email and Password: $password');
      _loginWithEmailAndPassword();
    }
  }

  _loginWithEmailAndPassword() async {
    responsiveButtonState.currentState.setProgressState();
    var authInstance = FirebaseAuth.instance;

    try {
      await authInstance.signInWithEmailAndPassword(
          email: email, password: password);
      //Login Completed
      print('Current User: ${authInstance.currentUser.toString()}');

      responsiveButtonState.currentState.setDoneState();

      Future.delayed(
          Duration(microseconds: 2000),
          () => Navigator.pushNamedAndRemoveUntil(
              context, LandingPage.name, (route) => false));
    } catch (e) {
      print(e);
      setState(() {
        generalErrorMessage = e.toString();
        print(e);
      });
      responsiveButtonState.currentState.setNormalState();
    }

    return;
  }
}

class ForgotPasswordBottomSheet extends StatefulWidget {
  @override
  _ForgotPasswordBottomSheetState createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  @override
  Widget build(BuildContext context) {
    String emailErrorMessage;
    String email;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Wrap(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Forgot Password',
                textAlign: TextAlign.left,
                style: kTextStyleHeadline,
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              Text(
                'Please enter your email address below to reset your password.',
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              RoundedStrokeTextField(
                errorText: emailErrorMessage,
                onChanged: (value) {
                  email = value;
                  print('on Changed was called: $email');
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                hintText: 'Email Address',
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              RoundTextButton(
                label: 'Send Reset Email',
                onClick: () {
                  print(
                      'Send Reset Email button was clicked with email: $email');
                  String emailValidationResponse = isValidEmail(email);
                  if (emailValidationResponse != 'YES') {
                    //Something is wrong with the email
                    setState(() {
                      emailErrorMessage = emailValidationResponse;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
