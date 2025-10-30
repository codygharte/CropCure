import 'package:flutter/material.dart';
import 'dart:async';
import 'package:crop_cure/presentation/auth/login/login_screen.dart';
import 'package:crop_cure/core/app_theme.dart'; // Import your AppTheme

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Set the background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'), // Ensure this path is correct
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CropCure',
                // Apply the PoltawskiNowy font from AppTheme
                style: AppTheme.poltawskiNowy.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"Detect early, harvest healthy."',
                // Apply the Poppins font from AppTheme
                style: AppTheme.poppins.copyWith(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

