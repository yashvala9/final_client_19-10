import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reel_ro/models/user_model.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createProfile(UserModel userModel) async {
    final docRef = _firestore.collection('users').doc();
    userModel = userModel.copyWith(
      id: docRef.id,
    );
    await docRef.set(userModel.toMap());
  }

  Future<UserModel?> getUserProfile(String id) async {
    return _firestore.collection("users").doc(id).get().then((value) {
      if (!value.exists) {
        return null;
      }
      return UserModel.fromMap(value.data()!);
    });
  }
}
