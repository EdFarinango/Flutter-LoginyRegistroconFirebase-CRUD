import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_register/src/app.dart';

import 'package:flutter_login_register/firebase_options.dart';
import 'package:flutter_login_register/src/cubits/authCubits.dart';
import 'package:flutter_login_register/src/repository/auth.dart';
import 'package:flutter_login_register/src/repository/implementation/authIm.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //Inicializamos con firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  await injeDependencies();


  runApp(  
    BlocProvider(
      create: (_)=> AuthCubit()..init(),
      child: const MyApp(),
    ),

    
  );
}

Future<void> injeDependencies()async {


  getIt.registerLazySingleton<Auth>(()=>AuthImp());
}





