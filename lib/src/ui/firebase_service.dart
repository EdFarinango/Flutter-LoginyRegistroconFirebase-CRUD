import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getUsers() async {
    QuerySnapshot querySnapshot = await firestore.collection('users').get();
    return querySnapshot.docs;
  }

  Future<void> addUser(String email, String rol) async {
    await firestore.collection('users').add({
      'email': email,
      'rol': rol,
    });
  }

  Future<void> updateUser(String id, String email, String rol) async {
    await firestore.collection('users').doc(id).update({
      'email': email,
      'rol': rol,
    });
  }
Future<void> deleteUserAccount(String uid) async {
  await firestore.collection('users').doc(uid).delete();
 

}

  getUserRol(String uid) {
    return firestore.collection('users').doc(uid).get();
    



  }
}

