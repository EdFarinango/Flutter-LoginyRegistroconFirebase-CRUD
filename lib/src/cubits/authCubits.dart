import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_register/main.dart';
import 'package:flutter_login_register/src/repository/auth.dart';



enum AuthState {
  initial,
  signedOut,
  signedIn
}

class AuthCubit extends Cubit<AuthState> {

  final Auth _auth = getIt();
  StreamSubscription? _authSubs;

  AuthCubit() : super(AuthState.initial);

  Future<void> init()async{
    _authSubs =
      _auth.onAuthStateChanged.listen(_authStateChanged);
  }

  void _authStateChanged(String? userUID){
    userUID == null ? emit(AuthState.signedOut): emit(AuthState.signedIn);

  }

  Future<void>singOut()async{
    await _auth.signOut();
    emit(AuthState.signedOut);
  }

  @override
  Future<void> close(){
    _authSubs?.cancel();
    return super.close();
  }

}