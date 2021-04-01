import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/components/buttons/rounded_filled_text_button.dart';
import 'package:flutter_loopez/constants.dart';
import 'package:flutter_loopez/screens/sign%20up/phone_number_verification.dart';

class SignUpWithPhoneNumber extends StatefulWidget {
  @override
  _SignUpWithPhoneNumberState createState() => _SignUpWithPhoneNumberState();
}

class _SignUpWithPhoneNumberState extends State<SignUpWithPhoneNumber> {
  final _focusNode = FocusNode();
  Color _strokeColor = Colors.black;
  String _phoneNumber;
  bool _isErrorVisible = false;
  String _errorMessage = 'Invalid Phone Number';
  bool _isProgressVisible = false;
  String _tempTestPhoneNumber = '+11111111111';
  @override
  void initState() {
    _focusNode.addListener(
      () {
        print('Focus: ${_focusNode.hasFocus}');
        if (_focusNode.hasFocus) {
          setState(() {
            _strokeColor = Colors.blue;
          });
        } else {
          setState(() {
            if (_isErrorVisible)
              _strokeColor = Colors.red;
            else
              _strokeColor = Colors.black;
          });
        }
      },
    );
  }

  Future<bool> _willPopScope() async {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    if (_isProgressVisible) {
      setState(
        () {
          _isProgressVisible = false;
        },
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopScope,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            //When clicked anywhere else on the screen
            if (_focusNode.hasFocus) _focusNode.unfocus();
          },
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Back Button
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
//                height: size.height * 0.09,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('< Back'),
                    ),
                  ),
                ),
                //Enter Phone Number
                Container(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Your Phone',
                          style: kTextStyleHeadline,
                        ),
                        Text('We will send a confirmation code to your phone'),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: new Border.all(
                              color: _strokeColor,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                ' +92 | ',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: _focusNode,
                                  onChanged: (value) {
                                    _phoneNumber = value;
                                    setState(() {
                                      _isErrorVisible = false;
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: 20, letterSpacing: 10),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counterStyle: TextStyle(
                                      height: double.minPositive,
                                    ),
                                    counterText: "",
                                  ),
                                  maxLines: 1,
                                  maxLength: 11,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _isErrorVisible,
                          child: Text(
                            _errorMessage,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Next button

                RoundTextButton(
                  label: 'Next',
                  onClick: _nextOnClick,
                  inProgress: _isProgressVisible,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _nextOnClick() {
    print('Button clicked');

    _gotoVerificationScreen('verificationId');
    return;

    if (_isProgressVisible) return;

    if (_phoneNumber == null ||
        _phoneNumber == '' ||
        _phoneNumber.length < 10) {
      setState(() {
        _strokeColor = Colors.red;
        _isErrorVisible = true;
      });
    } else {
      setState(() {
        _isProgressVisible = true;
        _sendCode();
      });
    }
  }

  void _sendCode() {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _tempTestPhoneNumber,
//      phoneNumber: '+92' + _phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        //TODO Handle verificationCompleted happens in Android
        print('Verification Completed: ${phoneAuthCredential.asMap()}');
      },
      verificationFailed: (FirebaseAuthException error) {
        print('Verification Failed: ${error.message}');

        setState(() {
          _isErrorVisible = true;
          _errorMessage = error.message;
        });
      },
      codeSent: (String verificationId, int forceResendingToken) {
        print('Code sent with verification ID: $verificationId');
        setState(() {
          _isProgressVisible = false;
        });
        _gotoVerificationScreen(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('CodeAutoRetrievalTimeout with verification ID: $verificationId');
      },
    );
  }

  void _gotoVerificationScreen(String verificationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PhoneNumberVerification(verificationId: verificationId),
      ),
    );
  }
}
