import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/decrypto_project/utilities/user_model.dart';

import 'auth_helper.dart';
import 'globals.dart';

class FireStorageHelper {
  FireStorageHelper._();

  static FireStorageHelper fireStorageHelper = FireStorageHelper._();
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, [String? directoryName]) async {
    String imageName = file.path.split('/').last;
    // 1 make reference for uploading image
    try {
      Reference reference = firebaseStorage.ref(directoryName == null
          ? 'users/imageName'
          : '$directoryName/$imageName');
      //2 upload the image
      await reference.putFile(file);
      String imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } on Exception {
      rethrow;
    }
  }
}

class FirestoreHelper {
  FirestoreHelper._();
  static FirestoreHelper fireStoreHelper = FirestoreHelper._();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String? userId;
  late User currentUser;
  late UserDecryptoModel userModel;
  // addImage(BuildContext context, String imagePath, String algorithm,
  //     String modeOperation,
  //     {String encryptedFile = ''}) async {
  //   DocumentReference<Map<String, dynamic>> doc =
  //       await fireStore.collection('images').add({
  //     'image': imagePath,
  //     'algorithm': algorithm,
  //     'modeOperation': modeOperation,
  //     'encryptedFile': encryptedFile
  //   });
  //   fireStore.collection('images').doc(doc.id).update({
  //     "id": doc.id,
  //     "encryptedFile": Provider.of<EncryptProvider>(context, listen: false)
  //         .encryptedFile!
  //         .bytes
  //   });
  // }

  createNewUser(UserDecryptoModel userModel, String userId) async {
    fireStore.collection('Users').doc(userId).set(userModel.toMap());
  }

  Future<UserDecryptoModel> getUser(String userId, BuildContext context) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await fireStore.collection('Users').doc(userId).get();
    UserDecryptoModel userModel =
        UserDecryptoModel.fromDocumentSnapShot(documentSnapshot);
    Globals.globals.userModel = userModel;
    // AppRouter.router.push(CryptoPageView(), context);

    return userModel;
  }

  getCurrentUser(BuildContext context) async {
    currentUser = AuthHelper.authHelper.getCurrentUserId()!;
    userId = currentUser.uid;
    if (currentUser != null) {
      userModel = await FirestoreHelper.fireStoreHelper
          .getUser(currentUser.uid, context);
    }
    return userModel;
  }
}
