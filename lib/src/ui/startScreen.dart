

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:page_indicator/page_indicator.dart';

const googleClientId= '3515536203-ai8l2d4k660scftd9bp3h6m5l8qeh7v8.apps.googleusercontent.com';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: _StartPager(),


    );
  }
}


class _StartPager extends StatelessWidget{

  final String exampleText = 'Hola que tal';


  @override
  Widget build(BuildContext context){

    return PageIndicatorContainer(
    align: IndicatorAlign.bottom,
    length: 4,
    indicatorSpace: 12,
    indicatorColor: Colors.blueAccent,
    indicatorSelectorColor: Colors.black,
    child: PageView(
      children: <Widget>[
        _DescriptionPage(text: exampleText, 
        imagePath: 'assets/img1.png'),
        _DescriptionPage(text: exampleText, 
        imagePath: 'assets/img2.png'),
        _DescriptionPage(text: exampleText, 
        imagePath: 'assets/img3.png'),
        _LoginPage()
       
      ],
    ),
      
      
    );
  }
}



//Para emplear las imagenes en cada indicador

class _DescriptionPage extends StatelessWidget{
  final String text;
  final String imagePath;

  const _DescriptionPage({
    super.key,
    required this.text,
    required this.imagePath
  });

  @override
  Widget build(BuildContext context){
    return Container(
   

      padding: const EdgeInsets.all(24.0),
      child: Column(
      
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            width: 300,
          
            height: 300,
          
          ),
          Expanded(child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ))
        ],
      ),
    );
  }
}


class _LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return const SignInScreen(

      providerConfigs:[

      
        GoogleProviderConfiguration(clientId: googleClientId),
        // FacebookProviderConfiguration(clientId: ''),
        EmailProviderConfiguration()
      ],
    );
  }
}
