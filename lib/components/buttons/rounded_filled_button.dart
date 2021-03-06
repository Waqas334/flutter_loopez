import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/constants.dart';

class RoundedStrokeButton extends StatelessWidget {
  String label;
  Widget icon;
  Function onClick;
  Widget image;

  RoundedStrokeButton({this.label, this.icon, this.onClick, this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(kButtonCornerRadius),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.center,
              width: 30,
              height: 30,
              child: (icon == null) ? image : icon,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
