import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedStrokeTextField extends StatefulWidget {
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FocusNode focusNode;
  int maxLength;
  TextStyle style;
  Function onChanged;
  String hintText;
  bool obscureText;
  Color strokeColor;
  String errorText;

  RoundedStrokeTextField(
      {this.keyboardType,
      this.textInputAction,
      this.hintText,
      this.errorText,
      this.focusNode,
      this.obscureText,
      this.strokeColor,
      this.maxLength,
      this.style,
      this.onChanged});

  @override
  _RoundedStrokeTextFieldState createState() => _RoundedStrokeTextFieldState();
}

class _RoundedStrokeTextFieldState extends State<RoundedStrokeTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
//        border: Border.all(color: widget.strokeColor ?? Colors.black),
      ),
      child: TextField(
        obscureText: widget.obscureText ?? false,
        style: widget.style,
        onChanged: widget.onChanged,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          errorText: (widget.errorText?.length == 0) ? null : widget.errorText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(color: Colors.red),
          ),
          counterStyle: TextStyle(
            height: double.minPositive,
          ),
          counterText: "",
        ),
        maxLength: widget.maxLength,
      ),
    );
  }
}
