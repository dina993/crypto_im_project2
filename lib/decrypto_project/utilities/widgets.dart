import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_constants.dart';

class TextFunctions {
  static user(BuildContext context, TextEditingController controller,
      {String? label,
      Function? validationFunction,
      Function? press,
      bool obscure = false,
      Widget? icon}) {
    return Padding(
      padding: const EdgeInsets.all(AppValues.m10),
      child: SizedBox(
        height: AppConstants.fieldSize,
        child: TextFormField(
          onTap: () => press,
          validator: (v) => validationFunction!(v),
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: Theme.of(context).textTheme.titleMedium,
            suffixIcon: icon,
          ),
        ),
      ),
    );
  }

  static showToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
        backgroundColor: AppColor.primaryButton,
        textColor: AppColor.white);
  }
}
