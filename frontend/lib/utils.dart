import 'package:flutter/material.dart';

const String serverUrl = 'http://localhost:5000';

void showSnackBar(String message, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    width: 1000,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
