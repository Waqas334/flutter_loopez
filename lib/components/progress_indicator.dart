import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProgressIndicator extends StatelessWidget {
  final String message;
  final bool inProgress;
  final Function onRetry;
  ProgressIndicator(
      {this.message: 'Please wait', this.inProgress: true, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (inProgress)
                ? CircularProgressIndicator()
                : Icon(
                    Icons.error,
                    size: 50,
                  ),
            SizedBox(
              height: 20,
            ),
            (inProgress)
                ? Text(message)
                : GestureDetector(
                    onTap: onRetry,
                    child: Center(
                      child: Column(
                        children: [
                          Text(message),
                          Text(
                            'Try Again',
                            style: kTextStyleClickable,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
