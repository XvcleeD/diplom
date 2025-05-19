import 'package:diplom/screens/history_screen.dart';
import 'package:diplom/screens/image_processing_screen.dart';
import 'package:diplom/screens/methods_screen.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // your existing theme code ...
      ),
      initialRoute: AppRoutes.welcome,

      // Remove static routes map, use onGenerateRoute for dynamic args
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.welcome:
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());

          case AppRoutes.signIn:
            return MaterialPageRoute(builder: (_) => const SignInScreen());

          case AppRoutes.signUp:
            return MaterialPageRoute(builder: (_) => const SignUpScreen());

          case AppRoutes.home:
            // Expect userId passed in arguments
            final args = settings.arguments;
            if (args is String) {
              return MaterialPageRoute(
                builder: (_) => HomeScreen(userId: args),
              );
            }
            // If no args passed, fallback to some error page or welcome
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());

          case AppRoutes.imageProcessing:
            return MaterialPageRoute(builder: (_) => const ImageProcessingScreen());

          case AppRoutes.history:
            return MaterialPageRoute(builder: (_) => const HistoryScreen());

          case AppRoutes.methods:
            return MaterialPageRoute(builder: (_) => const MethodsScreen());

          default:
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
        }
      },
    );
  }
}
