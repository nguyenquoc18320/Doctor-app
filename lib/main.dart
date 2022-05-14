import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:doctor_app/screens/user/signIn/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

Map<int, Color> swatch = {
  50: Color(0xFF3BF8FF),
  100: Color(0xFF3FD4FF),
  200: Color(0xFF42B3FE),
  300: Color(0xFF4594FB),
  400: Color(0xFF4977F7),
  500: Color(0xFF4C5DF4),
  600: Color(0xFF5140D8),
  700: Color(0xFF6035BB),
  800: Color(0xFF682A9E),
  900: Color(0xFF682080),
};

Map<int, Color> swatch1 = {
  50: Color(0xFFE4FEEB),
  100: Color(0xFFCBFCE6),
  200: Color(0xFFB2F9ED),
  300: Color(0xFF9AEBF5),
  400: Color(0xFF84C6F0),
  500: Color(0xFF75A2D9),
  600: Color(0xFF6780C2),
  700: Color(0xFF5962AB),
  800: Color(0xFF514C94),
  900: Color(0xFF4D3E7C),
};

Map<int, Color> swatch2 = {
  50: Color(0xFFD5FDF4),
  100: Color(0xFFB5FAF9),
  200: Color(0xFF96E2F6),
  300: Color(0xFF78BCF1),
  400: Color(0xFF5B8CEB),
  500: Color(0xFF3F52E4),
  600: Color(0xFF4335CA),
  700: Color(0xFF542BAF),
  800: Color(0xFF5E2294),
  900: Color(0xFF5F1A78),
};

Map<int, Color> swatch3 = {
  50: Color(0xFFFDDBE0),
  100: Color(0xFFFCBEC7),
  200: Color(0xFFFBA1AD),
  300: Color(0xFFFA93A1),
  400: Color(0xFFF8687B),
  500: Color(0xFFF74B62),
  600: Color(0xFFD84256),
  700: Color(0xFFB9384A),
  800: Color(0xFF9A2F3D),
  900: Color(0xFF7C2631),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(0xFFF74B62, swatch3)),
        scaffoldBackgroundColor: Color(0xFFF7F7F7),
        fontFamily: 'Lato',
        appBarTheme: AppBarTheme(elevation: 0),
        textTheme: const TextTheme(
            bodyText2: TextStyle(
              color: Color(0xFF000000),
              fontSize: 16,
            ),
            button: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      home: const SignInWidget(),
    );
  }
}
