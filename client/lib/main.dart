import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verdhale/src/screens/appointment/appointment_screen.dart';
import 'package:verdhale/src/screens/auth/login_screen.dart';
import 'package:verdhale/src/screens/auth/signup_screen.dart';
import 'package:verdhale/src/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    const VerdhaleApp(),
  );
}

class VerdhaleApp extends StatelessWidget {
  const VerdhaleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verdhale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: "/signupScreen",
      routes: {
        "/homeScreen": (context) => const HomeScreen(),
        "/loginScreen": (context) => const LoginScreen(),
        "/signupScreen": (context) => const SignUpScreen(),
        "/appointmentScreen": (context) => const AppointmentScreen(),
      },
    );
  }
}
