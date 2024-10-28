import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  String label = "";

  DividerWithText({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Expanded(child: Divider()),
      Text(label),
      const Expanded(child: Divider()),
    ]);
  }
}
