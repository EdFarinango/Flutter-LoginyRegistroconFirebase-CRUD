import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register/src/repository/auth.dart';
import 'package:flutter_login_register/src/ui/firebase_service.dart';
import 'package:flutter_login_register/src/ui/homeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
   FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> get usersStream => _usersRef.snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel de administración"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              return ListTile(
                title: Text(documentSnapshot['email']),
                subtitle: Text(documentSnapshot['rol']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    if (documentSnapshot['email'] != _auth.currentUser!.email)
                 
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserScreen(
                                userId: documentSnapshot.id,
                                email: documentSnapshot['email'],
                                rol: documentSnapshot['rol'],
                              ),
                            ),
                          );
                        },
                      ),

                    //verificar usuario logueado
                      
                    if (documentSnapshot['email'] != _auth.currentUser!.email)
                     
                      
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await firebaseService
                                .deleteUserAccount(documentSnapshot.id, UserUID);
                            Fluttertoast.showToast(msg: 'Usuario eliminado');
                          },
                        ),
                    if (documentSnapshot['email'] == _auth.currentUser!.email)
                    //if (documentSnapshot['rol'] == 'admin')
                        IconButton(
                          icon: Icon(Icons.edit_attributes),
                          onPressed: () async {
                           
                          },
                        ),
                  ],
                ),
              );
            },
          );


        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}