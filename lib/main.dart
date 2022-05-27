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

Map<int, Color> blueSwatch = {
  50: Color(0xFFebe3fc),
  100: Color(0xFFd7c7f8),
  200: Color(0xFFc4abf5),
  300: Color(0xFFb08ef2),
  400: Color(0xFF9c72ee),
  500: Color(0xFF8856eb),
  600: Color(0xFF754ac9),
  700: Color(0xFF613da8),
  800: Color(0xFF4e3186),
  900: Color(0xFF3a2565),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(0xFF4702A2, blueSwatch)),
        scaffoldBackgroundColor: Color(0xFFEEEAFB),
        fontFamily: 'Quicksand',
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
