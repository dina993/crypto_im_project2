import 'package:cloud_firestore/cloud_firestore.dart';

class UserDecryptoModel {
  String? id;
  String? email;
  String? password;

  UserDecryptoModel(this.id, this.email, this.password);

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'password': password};
  }

  UserDecryptoModel.fromDocumentSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.id;
    email = documentSnapshot.data()!['email'];
    password = documentSnapshot.data()!['password'];
  }
}
