import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class RoundTextButton extends StatefulWidget {
  final String label;
  final Function onClick;
  final bool inProgress;
  bool disabled;

  RoundTextButton({
    this.label: 'LABEL',
    this.onClick,
    this.inProgress: false,
    this.disabled: false,
  });

  void disabledButton(bool disableButton) {
    print('Disable Button was called');
    disabled = disableButton;
  }

  @override
  _RoundTextButtonState createState() {
    print('Create state was called');
    return _RoundTextButtonState();
  }
}

class _RoundTextButtonState extends State<RoundTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.disabled ? () {} : widget.onClick,
      child: Container(
        height: 50,
//        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//        padding: EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.disabled ? Colors.grey : Colors.blue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(kButtonCornerRadius),
        ),
        child: Center(
          child: widget.inProgress
              ? Container(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : Text(
                  widget.label,
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
