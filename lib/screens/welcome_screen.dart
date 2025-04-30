import 'package:flutter/material.dart';
import '../constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              const FlutterLogo(size: 120),
              const SizedBox(height: 32),
              Text(
                'Тавтай морилно уу',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Зургийн боловсруулалтын хэрэгсэл',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.signIn),
                child: const Text('Нэвтрэх'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.signUp),
                child: const Text('Бүртгүүлэх'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                child: Text(
                  'Зөвхөн үзэх',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}