/*
Auth Gate- verifie les changement de l'etat d'authentification
==================================

unauthenticated -> LoginPage
authenticated -> HomePage
*/

import 'package:flutter/material.dart';
import 'package:meetup/shared/main_page.dart';
import 'package:meetup/shared/splash_page.dart';
import 'package:meetup/views/auth/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
        //verification de la session d'authentification
         final session = snapshot.data;
         if (session != null) {
           return SplashPage();
         } else {
           return MainPage();
         }
      }
    );
  }
}