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

  runApp(MaterialApp(theme: ThemeData(), home: MyApp()));
}

Map<int, Color> blueSwatch = {
  50: Color(0xFFEFF6FF),
  100: Color(0xFFDBEAFE),
  200: Color(0xFFBFDBFE),
  300: Color(0xFF93C5FD),
  400: Color(0xFF60A5FA),
  500: Color(0xFF3B82F6),
  600: Color(0xFF2563EB),
  700: Color(0xFF1D4ED8),
  800: Color(0xFF1E40AF),
  900: Color(0xFF1E3A8A),
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
            primarySwatch: MaterialColor(0xFF4702A2, blueSwatch)),
        scaffoldBackgroundColor: Color(0xFFF7F7F7),
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(elevation: 0),
        textTheme: const TextTheme(
            bodyText2: TextStyle(
                color: Color(0xFF000000),
                fontSize: 16,
                fontWeight: FontWeight.w500),
            button: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ),
      home: const SignInWidget(),
    );
  }
}
