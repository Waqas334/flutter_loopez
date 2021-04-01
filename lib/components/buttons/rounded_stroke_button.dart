import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class RoundedFilledButton extends StatelessWidget {
  String label;
  IconData icon;
  Function onButtonClick;
  Widget image;

  RoundedFilledButton({this.label, this.icon, this.onButtonClick, this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonClick,
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(kButtonCornerRadius),
//          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.center,
              width: 30,
              height: 30,
              child: (icon == null)
                  ? image
                  : Icon(
                      icon,
                      color: Colors.white,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
