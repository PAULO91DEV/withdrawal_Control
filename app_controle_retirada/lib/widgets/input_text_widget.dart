import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  final Function onTextChanged;
  final bool isReadOnly;
  final String textLabel;
  final Widget icon;
  final String initialValue;

  const InputTextWidget({
    Key key,
    this.onTextChanged,
    this.textLabel,
    this.icon,
    this.isReadOnly = false,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        readOnly: isReadOnly,
        initialValue: this.initialValue,
        decoration: InputDecoration(
          labelText: textLabel,
          labelStyle: TextStyle(
            fontSize: 20,
            color: Colors.indigo,
          ),
          icon: icon,
        ),
        onChanged: onTextChanged,
        //this.loginController.setUser(value);
      ),
    );
  }
}
