import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meetup/controllers/authGate.dart';
import 'package:meetup/core/constants.dart';
import 'package:meetup/core/theme.dart';
import 'package:meetup/shared/main_page.dart';
import 'package:meetup/shared/splash_page.dart';
import 'package:meetup/views/discover/profile.dart';
import 'package:meetup/views/settings/profile_utilisateur.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.apiKey,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(colorScheme: ColorScheme.light(primary: Colors.black)),
      home:  AuthGate(),
    );
  }
}
