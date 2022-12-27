import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'decrypto_project/presentation/myApp.dart';
import 'decrypto_project/provider/encrypt_provider.dart';
import 'decrypto_project/provider/register_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => EncryptProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider())
  ], child: MyCryptoApp()));
}
