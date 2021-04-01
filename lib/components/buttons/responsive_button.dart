import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/constants.dart';

class ResponsiveButton extends StatefulWidget {
  final Function onTap;
  final String label;
  final bool enabled;

  @override
  ResponsiveButtonState createState() => ResponsiveButtonState();

  ResponsiveButton({Key key, this.onTap, this.label, this.enabled: false})
      : super(key: key);
}

class ResponsiveButtonState extends State<ResponsiveButton> {
  bool isEnabled;

  void enableButton() {
    print('Button enabled');
    setState(() {
      isEnabled = true;
    });
  }

  void disableButton() {
    print('Button disabled');
    setState(() {
      isEnabled = false;
    });
  }

  @override
  void initState() {
    isEnabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: isEnabled ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: kTextStyleButton,
            ),
          ),
        ),
      ),
    );
  }
}
