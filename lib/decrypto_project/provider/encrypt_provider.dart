import 'dart:async';
import 'dart:io';

import 'package:bitmap/bitmap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_des/dart_des.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled1/decrypto_project/utilities/app_constants.dart';

class EncryptProvider extends ChangeNotifier {
  File? image;
  File? newImage;
  String? decryptImage;
  File? desDecryptFile;
  File? aesDecryptFile;
  List<int>? encryptedDES;
  List<int>? decryptedDES;
  String keyDES = '12345678'; // 8-byte for DES
  List<int> ivDES = [1, 2, 3, 4, 5, 6, 7, 8];
  var items = [AppStrings.aes, AppStrings.des];
  var modeOperation = [AppStrings.cbcMode, AppStrings.ecbMode];
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final keyAES = Key.fromSecureRandom(16);
  final ivAES = IV.fromLength(16);
  File? aesEncryptFile;
  File? desEncryptFile;
  Encrypted? encryptedFile;
  dynamic headedBitmap;
  String? imageDec;
  String? idDoc;
  Uint8List? plainData;
  Uint8List? bytes;
////////////AES//////////////////////////
  _fromUint8List(Uint8List bytes) {
    Bitmap bitmap = Bitmap.fromHeadful(60, 60, bytes);
    notifyListeners();
    return bitmap;
  }

  // Future<Uint8List?> CBCFile(String image) async {
  //   final directory = await getExternalStorageDirectory();
  //   final encrypter = Encrypter(AES(keyAES, mode: AESMode.cbc));
  //   List<int> bytes = File(image).readAsBytesSync();
  //   encryptedFile = encrypter.encryptBytes(bytes, iv: ivAES);
  //   Bitmap bitmapImg = _fromUint8List(encryptedFile!.bytes);
  //   Bitmap contrastedBitmap = bitmapImg.apply(BitmapContrast(0.2));
  //   headedBitmap = contrastedBitmap.buildHeaded();
  //   aesEncryptFile =
  //       await File('${directory!.path}/aes.jpg').writeAsBytes(headedBitmap);
  //   getCBCFile(encryptedFile!.bytes, image, keyAES);
  //   notifyListeners();
  //   return encryptedFile!.bytes;
  // }
  //
  // Future<Uint8List?> ECBFile(String image) async {
  //   final directory = await getExternalStorageDirectory();
  //   final encrypter = Encrypter(AES(keyAES, mode: AESMode.ecb));
  //   List<int> bytes = File(image).readAsBytesSync();
  //   encryptedFile = encrypter.encryptBytes(bytes);
  //   Bitmap bitmapImg = _fromUint8List(encryptedFile!.bytes);
  //   Bitmap contrastedBitmap = bitmapImg.apply(BitmapContrast(0.2));
  //   headedBitmap = contrastedBitmap.buildHeaded();
  //   aesEncryptFile =
  //       await File('${directory!.path}/aes.jpg').writeAsBytes(headedBitmap);
  //   getECBFile(encryptedFile!.bytes, image, keyAES);
  //   notifyListeners();
  //   return encryptedFile!.bytes;
  // }

  Future<Uint8List> readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = File.fromUri(myUri);
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes!;
  }

  Future<String?> decryptCBC(String file, var keys, var iv) async {
    final directory = await getExternalStorageDirectory();
    Uint8List x = Uint8List.fromList(keys);
    final aeskey = enc.Key(x);
    final ivv = enc.IV(iv);
    readFileByte(file).then((bytesData) {
      plainData = bytesData;
    });
    plainData = await File(file).readAsBytes();
    Encrypted encrypt = Encrypted(plainData!);
    final encrypted = Encrypter(AES(
      aeskey,
      mode: AESMode.cbc,
    ));
    final decryptDES = encrypted.decryptBytes(encrypt, iv: ivv);
    notifyListeners();
  }

  Future<String?> decryptECB(String file, var keys, var iv) async {
    final directory = await getExternalStorageDirectory();
    Uint8List x = Uint8List.fromList(keys);
    final aeskey = enc.Key(x);
    final ivv = enc.IV(iv);
    readFileByte(file).then((bytesData) {
      plainData = bytesData;
    });
    print(plainData);
    Encrypted encrypt = Encrypted(plainData!);
    final encrypted = Encrypter(AES(
      aeskey,
      mode: AESMode.ecb,
    ));
    var decryptDES = encrypted.decryptBytes(encrypt, iv: ivv);
    notifyListeners();
  }

  Future<Uint8List?> readImageFile(File imageFile) async {
    if (!(await imageFile.exists())) {
      return null;
    }
    return await imageFile.readAsBytes();
  }

  decryptECBFile(Uint8List encryptedImage, var key, var iv) {
    Encrypted encrypt = Encrypted(Uint8List.fromList(encryptedImage));
    final encrypted = Encrypter(AES(key, mode: AESMode.ecb, padding: "PKCS7"));
    return encrypted.decryptBytes(encrypt, iv: iv);
  }

  // decryptCBCFile(var key, var iv) {
  //   Encrypted encrypt = Encrypted(Uint8List.fromList(encryptedImage));
  //   final encrypted = Encrypter(AES(key, mode: AESMode.cbc,));
  //   return encrypted.decryptBytes(encrypt, iv: iv);
  // }

  Future<String> writeData(data, File filePath) async {
    await filePath.writeAsBytes(data);
    return filePath.absolute.toString();
  }

  /////////////DES/////////////////////////////////////////
  desCBC(String image, data, DESMode mod) async {
    var desKey = keyDES.split('').map(int.parse).toList();
    try {
      DES desCBC = DES(
        key: desKey,
        mode: mod,
        iv: ivDES,
      );
      List<int> bytes = File(image).readAsBytesSync();
      encryptedDES = desCBC.encrypt(bytes);
      Bitmap bitmapImg = _fromUint8List(Uint8List.fromList(encryptedDES!));
      Bitmap contrastedBitmap = bitmapImg.apply(BitmapContrast(0.3));
      headedBitmap = contrastedBitmap.buildHeaded();
      desCBCDecrypt();
      notifyListeners();
      return Uint8List.fromList(encryptedDES!);
    } catch (e) {
      rethrow;
    }
  }

  desECB(String image, data, DESMode mod) async {
    var DESkey = keyDES.split('').map(int.parse).toList();
    final directory = await getExternalStorageDirectory();
    try {
      DES desCBC = DES(
        key: DESkey,
        mode: mod,
      );
      List<int> bytes = File(image).readAsBytesSync();
      encryptedDES = desCBC.encrypt(bytes);
      Bitmap bitmapImg = _fromUint8List(Uint8List.fromList(encryptedDES!));
      Bitmap contrastedBitmap = bitmapImg.apply(BitmapContrast(0.3));
      headedBitmap = contrastedBitmap.buildHeaded();
      desEncryptFile =
          await File('${directory!.path}/des.jpg').writeAsBytes(headedBitmap);
      notifyListeners();
      desECBDecrypt();
      return Uint8List.fromList(encryptedDES!);
    } catch (e) {
      rethrow;
    }
  }

  desCBCDecrypt() async {
    var desKey = keyDES.split('').map(int.parse).toList();
    final directory = await getExternalStorageDirectory();
    DES desCBC = DES(
      key: desKey,
      mode: DESMode.CBC,
      iv: ivDES,
    );
    decryptedDES = desCBC.decrypt(encryptedDES!);
    aesDecryptFile = await File('${directory!.path}/test.jpg')
        .writeAsBytes(Uint8List.fromList(decryptedDES!));
    return decryptedDES;
  }

  desECBDecrypt() async {
    var desKey = keyDES.split('').map(int.parse).toList();
    final directory = await getExternalStorageDirectory();
    DES desCBC = DES(
      key: desKey,
      mode: DESMode.ECB,
    );
    // Uint8List? encryptedDES = await File(file).readAsBytes();
    decryptedDES = desCBC.decrypt(encryptedDES!);
    aesDecryptFile = await File('${directory!.path}/test.jpg')
        .writeAsBytes(Uint8List.fromList(decryptedDES!));
    print('decrypted : ${(decryptedDES!)}');
    return decryptedDES;
  }

  // desEncrypt(data, DESMode mod) async {
  //   var DESkey = keyDES.split('').map(int.parse).toList();
  //   final directory = await getExternalStorageDirectory();
  //   try {
  //     DES desCBC = DES(
  //       key: DESkey,
  //       mode: mod,
  //       iv: ivDES,
  //     );
  //     List<int> bytes = image!.readAsBytesSync();
  //     encryptedDES = desCBC.encrypt(bytes);
  //     Bitmap bitmapImg = _fromUint8List(Uint8List.fromList(encryptedDES!));
  //     Bitmap contrastedBitmap = bitmapImg.apply(BitmapContrast(0.3));
  //     headedBitmap = contrastedBitmap.buildHeaded();
  //     desEncryptFile =
  //         await File('${directory!.path}/des.jpg').writeAsBytes(headedBitmap);
  //     TextFunctions.showToast(
  //         'The Encryption has been completed unsuccessfully.');
  //     notifyListeners();
  //     return Uint8List.fromList(encryptedDES!);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
