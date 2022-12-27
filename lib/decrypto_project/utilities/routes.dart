import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static AppRouter router = AppRouter._();
  pushToNewWidget(Widget widget, BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => widget));
  }

  push(Widget widget, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
  }
}
