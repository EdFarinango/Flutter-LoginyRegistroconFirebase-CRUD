

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register/src/ui/homeScreen.dart';
import 'package:flutter_login_register/src/ui/splashScreen.dart';
import 'package:flutter_login_register/src/ui/startScreen.dart';

class Routes {
  //Definimos las rutas que tendra la aplicacion
  static const splash = '/';
  static const start = '/start';
  static const home = '/home';

  static Route routes(RouteSettings settings){
    MaterialPageRoute buildRoute(Widget widget){
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }
    switch(settings.name){
      case splash:
        return buildRoute(const SplashScreen());

      case start:
        return buildRoute(const StartScreen());

      case home:
        return buildRoute(const HomeScreen());

      default:
        throw Exception('La ruta no existe');
    }
  }

}