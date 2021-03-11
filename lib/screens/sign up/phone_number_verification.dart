import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_loopez/screens/components/buttons/rounded_filled_text_button.dart';

class PhoneNumberVerification extends StatefulWidget {
  @override
  _PhoneNumberVerificationState createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  final _focusNode = FocusNode();
  var _strokeColor = Colors.black;

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
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
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
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
//                  shape: RoundedRectangleBorder(),
                    ),
                child: TextButton(
                  onPressed: () {},
                  child: Text('Next'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
