import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_loopez/screens/components/buttons/rounded_filled_text_button.dart';
import 'package:flutter_loopez/screens/components/buttons/rounded_stroke_button.dart';
import 'package:flutter_loopez/screens/components/buttons/rounded_filled_button.dart';
import 'package:flutter_loopez/screens/sign%20up/phone_number_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/body.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: MyColumn(),
//      body: Body(),
    ));
  }
}

class MyColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                print('Skip clicked');
              },
              child: Container(
                height: size.height * 0.09,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
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
              Text('The trusted community of buyers and sellers')
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
                onButtonClick: () {
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
                onButtonClick: () {},
              ),
              RoundedStrokeButton(
                label: 'Continue with Facebook',
                image: SvgPicture.asset("assets/icons/facebook.svg"),
                onButtonClick: () {},
              ),
              RoundedFilledButton(
                label: 'Continue with Email',
//                image: SvgPicture.asset("assets/icons/facebook.svg"),
                icon: Icons.email,
                onButtonClick: () {},
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
    );
  }
}
