import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_register/admin.dart';
import 'package:flutter_login_register/screens/screens.dart';

import 'package:flutter_login_register/src/cubits/authCubits.dart';
import 'package:flutter_login_register/src/cubits/homeCubit.dart';
import 'package:flutter_login_register/src/model/myuser.dart';
import 'package:flutter_login_register/src/ui/widgets/customImage.dart';
import 'package:flutter_login_register/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


import '../navigation/routes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
User? _currentUser = _auth.currentUser;
String? _currentUserRol;

    return MaterialApp(
      title: 'Lista de usuarios registrados',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
  
}


class UserListScreen extends StatelessWidget {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');
      

  Stream<QuerySnapshot> get usersStream => _usersRef.snapshots();

  Future<void> signOut() async {
    await _auth.signOut();
  }
  
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('User List'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await signOut();
          },
        ),
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
                
              ),
            );
          },
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.map),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoadingScreen(),
          ),
        );
      },
    ),
    bottomNavigationBar: BottomAppBar(
      child: Container(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_auth.currentUser!.email == 'epfarinango@gmail.com')
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Teacher(),
                    ),
                  );
                },
                child: const  Text('Administrar usuarios'),
              ),
          ],
        ),
      ),
    ),

  );
}

  
}


Future<String?> _currentUserRol() async {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');
  User? _currentUser = _auth.currentUser;
  String? _currentUserRol;
  _currentUserRol = await firebaseService.getUserRol(_currentUser!.uid);
  print(_currentUserRol);
  return _currentUserRol;

}





class EditUserScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String rol;

  const EditUserScreen({
    Key? key,
    required this.userId,
    required this.email,
    required this.rol,
  }) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _rolController = TextEditingController();
  final _controller = StreamController<List<String>>();
  late Timer _timer;

  @override
  void initState() {


    super.initState();
    _emailController.text = widget.email;
    _rolController.text = widget.rol;
    _timer = Timer.periodic(Duration(seconds:5), (timer) async {
      final users = await FirebaseService().getUsers();
      _controller.add(users.cast<String>());
    }
);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar usuario'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Debe ingresar el Email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _rolController,
              decoration: InputDecoration(
                labelText: 'Rol',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Debe ingresar el Rol';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await FirebaseService().updateUser(
                    widget.userId,
                    _emailController.text,
                    _rolController.text,
                  );
                  Fluttertoast.showToast(msg: 'Usuario actualizado');
                  Navigator.pop(context);
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}



