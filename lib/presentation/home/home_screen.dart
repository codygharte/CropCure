import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../scan/scan_screen.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/ai_scanner_card.dart';
import 'widgets/scanned_plant_card.dart';
import 'widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final ImagePicker _picker = ImagePicker();

  // Sample scanned plants data
  final List<Map<String, dynamic>> _scannedPlants = [
    {
      'id': '1',
      'plantName': 'Tomato',
      'diseaseName': 'Fusarium Wilt',
      'imagePath': 'assets/images/tomato_sample.jpg',
      'scanDate': '2024-01-15',
      'confidence': 0.95,
    },
    {
      'id': '2',
      'plantName': 'Rose Plant (Leaf)',
      'diseaseName': 'Black Spot',
      'imagePath': 'assets/images/rose_sample.jpg',
      'scanDate': '2024-01-14',
      'confidence': 0.88,
    },
    {
      'id': '3',
      'plantName': 'Potato',
      'diseaseName': 'Common Scab',
      'imagePath': 'assets/images/potato_sample.jpg',
      'scanDate': '2024-01-13',
      'confidence': 0.92,
    },
  ];

  void _onTakePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Navigate to scan screen with the captured image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanScreen(imagePath: image.path),
        ),
      );
    }
  }

  void _onUploadPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Navigate to scan screen with the selected image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanScreen(imagePath: image.path),
        ),
      );
    }
  }

  void _onViewDetail(String plantId) {
    // Navigate to detail screen
    // This would typically show more information about the scanned plant
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for plant $plantId')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Plant Scanner Card
                    AiScannerCard(
                      onTakePhoto: _onTakePhoto,
                      onUploadPhoto: _onUploadPhoto,
                    ),

                    const SizedBox(height: 24),

                    // Scanned Plants Section
                    const Text(
                      'Scanned Plants',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Scanned Plants List
                    ..._scannedPlants
                        .map((plant) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ScannedPlantCard(
                                plant: plant,
                                onViewDetail: () => _onViewDetail(plant['id']),
                              ),
                            ))
                        .toList(),

                    const SizedBox(height: 80), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Handle navigation
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScanScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}
