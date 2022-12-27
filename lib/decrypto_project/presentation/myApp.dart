import 'package:flutter/material.dart';

import '../utilities/themes.dart';
import 'decoder_screen.dart';

class MyCryptoApp extends StatefulWidget {
  const MyCryptoApp._internal(); //named constructor

  static const MyCryptoApp _instance =
      MyCryptoApp._internal(); //singleton or singleton's instance

  factory MyCryptoApp() => _instance;
  @override
  State<MyCryptoApp> createState() => _MyCryptoAppState();
}

class _MyCryptoAppState extends State<MyCryptoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationThemes(),
      home: DecoderPageView(),
      // navigatorKey: AppRouter.router.navigatorKey,
    );
  }
}
