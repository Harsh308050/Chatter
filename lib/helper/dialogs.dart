import 'package:flutter/material.dart';

class dialogs {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.blue.withOpacity(.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(
              child: CircularProgressIndicator(
                color: Colors.blue[300],
                backgroundColor: Colors.blue[500],
              ),
            ));
  }
}
