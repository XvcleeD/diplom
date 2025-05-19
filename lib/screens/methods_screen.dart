// screens/methods_screen.dart
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MethodsScreen extends StatelessWidget {
  const MethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    final List<StepItem> steps = [
      StepItem(
        title: 'Зураг сонгох',
        description: 'Гар утасны сангаас зургаа сонгоно',
        icon: Icons.photo_library,
      ),
      StepItem(
        title: 'Зураг илгээх',
        description: 'Сервер рүү илгээнэ',
        icon: Icons.upload,
      ),
      StepItem(
        title: 'Температур шинжилгээ',
        description: 'Зургийн температурыг шинжилнэ',
        icon: Icons.thermostat,
      ),
      StepItem(
        title: 'Үр дүн харах',
        description: 'Боловсруулсан үр дүнг харах',
        icon: Icons.visibility,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Боловсруулах арга'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFFB497BD),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB497BD),
                    Color(0xFFD1B3C4),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Зургийн боловсруулалтын заавар',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Дараах алхмуудыг дагаж зургаа боловсруулна уу',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/app_guide.png',
                    height: 150,
                  ),
                ],
              ),
            ),

            // Steps Slider
            SizedBox(
              height: 240,
              child: PageView.builder(
                controller: _pageController,
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return _buildStepCard(steps[index]);
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: steps.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Color(0xFFB497BD),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Camera Usage Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Температурын камерын хэрэглээ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D3F6A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Температурын камерыг зөв байрлуулж, объектод төвлөрсөн байхыг анхаарна уу. '
                            'Хэтэрхий хол байвал үр дүн үнэн зөв гардаггүй.',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 15),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/camera_placement.jpg',
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(StepItem step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Card(
        elevation: 5,
        shadowColor: Colors.purple.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E6F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.icon,
                  size: 32,
                  color: const Color(0xFF8E44AD),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                step.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepItem {
  final String title;
  final String description;
  final IconData icon;

  StepItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
