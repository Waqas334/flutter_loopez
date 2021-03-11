import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/screens/components/buttons/rounded_filled_button.dart';
import 'package:flutter_loopez/screens/components/buttons/rounded_filled_text_button.dart';
import 'package:flutter_loopez/screens/components/home_components/rounded_input_field.dart';
import 'package:flutter_loopez/screens/sign%20up/phone_number_verification.dart';

class SignUpWithPhoneNumber extends StatefulWidget {
  @override
  _SignUpWithPhoneNumberState createState() => _SignUpWithPhoneNumberState();
}

class _SignUpWithPhoneNumberState extends State<SignUpWithPhoneNumber> {
  final _focusNode = FocusNode();
  Color _strokeColor = Colors.black;
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

    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                Container(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Your Phone',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
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
                                  style: TextStyle(fontSize: 20),
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: Center(
                        child: RoundTextButton(
                          label: 'Next',
                          onClick: _nextOnClick,
                        ),
                      ),
                    ),
                  ],
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhoneNumberVerification()),
    );
  }
}
