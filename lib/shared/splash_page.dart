import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetup/controllers/authGate.dart';
import 'package:meetup/core/constants.dart';
import 'package:meetup/core/theme.dart';
import 'package:meetup/main.dart';
import 'package:meetup/shared/avatar.dart';
import 'package:meetup/shared/main_page.dart';
import 'package:meetup/shared/welcome.dart';
import 'package:meetup/views/auth/login.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

 /* @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateAfterDelay();
  }*/

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: AppConstants.slowAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _navigateAfterDelay();
  });

  _initializeAnimations();
}

  void _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthGate()),
    );
  }
  


  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.pink,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo et Animation
              AnimatedBuilder(
                animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '❤️',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            AppConstants.appName,
                            style: AppTheme.headlineLarge.copyWith(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            AppConstants.appDescription,
                            style: AppTheme.bodyLarge.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // Animation de Chargement
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                        strokeWidth: 3,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Connecting hearts across Africa...',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Version de l'application
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Version ${AppConstants.appVersion}',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
