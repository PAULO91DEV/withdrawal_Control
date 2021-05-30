import 'package:flutter/material.dart';

extension CreatePopup on State<StatefulWidget> {
  Future showAlertDialog({
    @required String title,
    @required String subtitle,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 280, bottom: 270, right: 20, left: 20),
          child: AlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                child: Text(
                  title,
                ),
              ),
            ),
            content: Column(
              children: [
                Text(
                  subtitle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
