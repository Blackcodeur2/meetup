import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:meetup/views/auth/login.dart';
import 'package:meetup/views/auth/register.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  final List<Map<String, String>> slides = const [
    {
      'image': 'images/avatar.jpg',
      'text':
          'Rencontrez des personnes près de chez vous pour des amitiés sincères.',
    },
    {
      'image': 'images/meetup-logo.png',
      'text': 'Profitez d\'une interface sécurisée et simple pour échanger.',
    },
    {
      'image': 'images/avatar.jpg', 
      'text': 'Participez à des événements et activités exclusifs.',
    },
    {
      'image': 'images/avatar.jpg',
      'text': 'Recevez des recommandations personnalisées selon vos intérêts.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // fond clair
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo ou icône cœur en haut
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "CamerMatch",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.black87),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              // Icône cœur centrale
              const Icon(Icons.favorite, size: 64, color: Colors.pink),
              const SizedBox(height: 24),
              // Carousel d'images avec descriptions
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: slides.map((slide) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              slide['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide['text']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              // Boutons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Se connecter",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "S'inscrire",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
