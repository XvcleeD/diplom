// screens/methods_screen.dart
import 'package:flutter/material.dart';

class MethodsScreen extends StatelessWidget {
  const MethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Боловсруулах арга'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Зургийн боловсруулалтын заавар',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStep('1. Зураг сонгох', 'Гар утасны сангаас зургаа сонгоно.'),
            _buildStep('2. Зураг илгээх', 'Сервер рүү илгээнэ.'),
            _buildStep('3. Температур шинжилгээ', 'Зургийн температурыг шинжилнэ.'),
            _buildStep('4. Үр дүн харах', 'Боловсруулсан үр дүнг харах.'),
            const SizedBox(height: 24),
            const Text(
              'Температурын камерын хэрэглээ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Температурын камерыг зөв байрлуулж, объектод төвлөрсөн байхыг анхаарна уу. '
              'Хэтэрхий хол байвал үр дүн үнэн зөв гардаггүй.',
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/camera_placement.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}