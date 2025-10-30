import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  final String? imagePath;

  const ScanScreen({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Scanner'),
        backgroundColor: const Color(0xFF2DBE62),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              imagePath != null 
                ? 'Processing image...' 
                : 'Scan Screen',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            if (imagePath != null) ...[
              const SizedBox(height: 8),
              Text(
                'Image path: $imagePath',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
