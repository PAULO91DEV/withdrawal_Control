import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final Function onPressed;
  final bool isEnabled;
  final String text;

  const RoundedButtonWidget({
    Key key,
    this.onPressed,
    this.isEnabled = true,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: RaisedButton(
        disabledColor: Colors.indigo[200],
        onPressed: isEnabledBotton(this.onPressed),
        color: Colors.lightBlue,
        child: Text(
          this.text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: (this.isEnabled == true ? Colors.white : Colors.indigo),
            fontSize: 24.0,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
      ),
    );
  }

  Function isEnabledBotton(Function onPressed) {
    if (this.isEnabled) {
      return onPressed;
    }
    return null;
  }
}
