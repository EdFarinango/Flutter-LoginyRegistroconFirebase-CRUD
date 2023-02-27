import 'package:flutter/material.dart';
import 'package:flutter_login_register/src/cubits/authCubits.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CircularProgressIndicator(),
            // SizedBox(height: 24),
            // Text('Cargando...', style: TextStyle(fontSize: 24)),
            const Text('Pantalla de inicio', style: TextStyle(fontSize: 24)),
            ElevatedButton(onPressed: (){
              context.read<AuthCubit>().singOut();

            },
              child: const Text('sign out') 
            )
          ],
        ),
      )


    );
  }
}