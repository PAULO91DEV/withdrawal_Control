import 'package:flutter/material.dart';

class ButtonConfirmWidget extends StatelessWidget {
  final String text;
  final Function onPressed;
  const ButtonConfirmWidget({
    Key key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            child: RaisedButton(
                disabledColor: Colors.indigo[200],
                color: Colors.indigo[900],
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                onPressed: this.onPressed),
          ),
        )
      ],
    );
  }
}
