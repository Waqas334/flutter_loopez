import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

enum ButtonState { NORMAL, PROGRESS, DONE, ERROR }

class ProgressIndicatingButton extends StatefulWidget {
  final Function onTap;
  final String title;

  @override
  ProgressIndicatingButtonState createState() =>
      ProgressIndicatingButtonState();

  ProgressIndicatingButton({Key key, this.onTap, this.title: 'TITILE'})
      : super(key: key);
}

class ProgressIndicatingButtonState extends State<ProgressIndicatingButton> {
  ButtonState buttonState = ButtonState.NORMAL;

  void setNormalState() {
    setState(() {
      buttonState = ButtonState.NORMAL;
    });
  }

  void setProgressState() {
    setState(() {
      buttonState = ButtonState.PROGRESS;
    });
  }

  void setDoneState() {
    setState(() {
      buttonState = ButtonState.DONE;
    });
  }

  void setErrorState() {
    setState(() {
      buttonState = ButtonState.ERROR;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        buttonState = ButtonState.NORMAL;
      });
      print('Button State back to normal was set');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Expanded(
          child: Container(
//                    width: 200,
            decoration: BoxDecoration(
              color:
                  buttonState == ButtonState.ERROR ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            height: 50,
            child: buttonState == ButtonState.NORMAL
                ? Center(
                    child: Text(
                      widget.title,
                      style: kTextStyleButton,
                    ),
                  )
                : buttonState == ButtonState.PROGRESS
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )
                    : buttonState == ButtonState.ERROR
                        ? Container(
                            child: Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 45,
                              ),
                            ),
                          )
                        : Container(
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 45,
                              ),
                            ),
                          ),
          ),
        ),
      ),
    );
  }
}
