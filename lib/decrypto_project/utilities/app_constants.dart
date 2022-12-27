import 'dart:ui';

class AppConstants {
  static const double fieldSize = 55;
  static const double borderSize = 4;
  static const double borderWidth = 1;
  static const int delay = 5;
  static const double elevation = 1;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double radius = 150;
  static const double opacity = 0.08;
  static const double imageOpacity = 0.4;
  static const double top = -150.0;
  static const double right = -100.0;
  static const double left = 190.0;
  static const double bottom = 670.0;
  static const double width = 320.32;
  static const double height = 60.0;
  static const double imageHeight = 100.0;
  static const double imageWidth = 140.0;
}

class AppValues {
  static const double p15 = 15;
  static const double m10 = 10;
}

class AssetsManger {
  static const String imagePath = 'assets/images';
  static const String splashImage = '$imagePath/back.svg';
  static const String lockImage = '$imagePath/lock.png';
  static const String backImage = '$imagePath/background.jpg';
  static const String logoImage = '$imagePath/logo.jpg';
  static const String pickImage = '$imagePath/camera.png';
}

class AppColor {
  static Color primaryBackground =
      const Color(0xffFFFFFF).withOpacity(AppConstants.opacity);
  static const Color white = Color(0xffFFFFFF);
  static const Color blue = Color(0xff0074B7);
  static const Color primaryButton = Color(0xffEF1F75);
  static const Color black = Color(0xff000000);
  static const Color grey = Color(0xff808080);
}

class AppStrings {
  static String encryptedData = '';
  static String decryptedData = '';
  static const login = "Sign In";
  static const signUp = "Sign Up";
  static const loginPage = "Login Page";
  static const signUpPage = "SignUp Page";
  static const logout = "Logout";
  static const password = "Password";
  static const email = "Email";
  static const String notFound = "The Page is not Found";
  static const String title = "Encryption Page";
  static const String decoderTitle = "Description Page";
  static const String dropDownTitle =
      "Choose The type of Encryption Algorithm to perform";
  static const String decryptTitle = "Now ! Decrypt the image to display";
  static const String subTitle = "Choose The type of mode operation ";
  static const String imageTitle = "Choose an image to be send ";
  static const String aes = "AES";
  static const String cbcMode = "CBC";
  static const String ecbMode = "ECB";
  static const String des = "DES";
  static const String encryption = "Encryption";
  static const String decryption = "Decryption";
  static const String clear = "clear Details";
  static const String chooseKeyLength = "Choose The KEY Length";
  static const haveAccount = "Don't have an account";
  static const doHaveAccount = "Do you have an account";
}

class FontFamilyConstants {
  static const String montserrat = "Montserrat";
}

class FontWeightConstants {
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
}

class FontSize {
  static const double s14 = 14;
  static const double s15 = 15;
  static const double s18 = 18;
  static const double s22 = 22;
}
