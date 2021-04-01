import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_loopez/components/buttons/rounded_filled_text_button.dart';
import 'package:flutter_loopez/constants.dart';
import 'package:flutter_loopez/screens/home_screen.dart';

class PhoneNumberVerification extends StatefulWidget {
  String verificationId;

  PhoneNumberVerification({this.verificationId});

  @override
  _PhoneNumberVerificationState createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  final _focusNode = FocusNode();
  var _strokeColor = Colors.black;
  var _smsCode;
  bool _isInProgress = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(
          () {
            _strokeColor = Colors.blue;
          },
        );
      } else {
        setState(() {
          _strokeColor = Colors.black;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          print('Somewhere else clicked');
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                }, // Handle your callback
                child: Ink(
                  height: 50,
                  width: 70,
//                color: Colors.blue,
                  child: Center(child: Text('< Back')),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: kTextStyleHeadline,
                    ),
                    Text('We have sent a 6-digit code at ***********'),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(color: _strokeColor),
                      ),
                      child: TextField(
                        style: TextStyle(letterSpacing: 50),
                        maxLength: 6,
                        onChanged: (value) {
                          _smsCode = value;
                        },
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              RoundTextButton(
                label: 'Next',
                onClick: _verifyCode,
                inProgress: _isInProgress,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyCode() async {
    setState(() {
      _isInProgress = true;
    });

    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: widget.verificationId, smsCode: _smsCode))
        .then((value) async {
      if (value.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    });
    return;

    var credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: _smsCode);
    print('Credentials: ${credential.asMap()}');

    FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => () {
              print('User :${value.toString()}');
            })
        .catchError((onError) {
      print('Error signInWithCredential :${onError}');
    });
    FirebaseAuth.instance
        .signInWithCredential(credential)
        .then(
          (value) => {
            if (value == null)
              {print('Value is null')}
            else
              print('Logged in: ${value}'),
          },
        )
        .catchError((onError) {
      print('OnError SignInWith Credentials: ${onError}');
    });
  }
}
