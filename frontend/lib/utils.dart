import 'package:flutter/material.dart';

const String serverUrl = 'https://z126gbzs-5000.inc1.devtunnels.ms';

void showSnackBar(String message, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    width: 1000,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
