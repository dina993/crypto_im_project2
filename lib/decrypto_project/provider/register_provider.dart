import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../utilities/auth_helper.dart';
import '../utilities/helper.dart';
import '../utilities/user_model.dart';

class UserProvider extends ChangeNotifier {
  bool showPassword = true;
  final registerKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  registerUser() async {
    if (registerKey.currentState!.validate()) {
      User? user =
          await AuthHelper.authHelper.register(email.text, password.text);
      UserDecryptoModel userModel =
          UserDecryptoModel(user!.uid, email.text, password.text);
      FirestoreHelper.fireStoreHelper.createNewUser(userModel, user.uid);
      // getCurrentUser();
    } else {
      return;
    }
  }

  login(BuildContext context) async {
    if (loginKey.currentState!.validate()) {
      User? user = await AuthHelper.authHelper.login(email.text, password.text);
      await FirestoreHelper.fireStoreHelper.getUser(user!.uid, context);
      FirestoreHelper.fireStoreHelper.getCurrentUser(context);
    } else {
      return;
    }
  }

  emailValidation(String value) {
    if (value.isEmpty) {
      return 'حقل مطلوب';
    } else if (!isEmail(value)) {
      return 'الايميل غير صحيح';
    }
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return 'حقل مطلوب';
    } else if (value.length < 6) {
      return "النص الذي تم إدخاله يجب أن يكون أكثر من 6 حروف";
    }
  }

  showPass() {
    showPassword = !(showPassword);
    notifyListeners();
  }
}
