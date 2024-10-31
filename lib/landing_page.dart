import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'inventory_page.dart';
import 'maps_page.dart';
import 'settings_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 1; // Set the default index to the Home icon

  // Method to get the appropriate page based on the selected index
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const MapsPage(); // Map page
      case 2:
        return const InventoryPage(); // Inventory page
      default:
        return _buildHomePage(); // Home page (Landing page content)
    }
  }

  // Landing page content
  Widget _buildHomePage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.kitchen,
              size: 140,
              color: Color.fromARGB(255, 234, 200, 8),
            ),
            const SizedBox(height: 20),
            _buildSpeechBubble(
              'Every day, millions of people lack nutritious food',
            ),
            const SizedBox(height: 10),
            _buildSpeechBubble(
              'At the same time, people waste food',
            ),
            const SizedBox(height: 20),
            const Text(
              "Food Bridge's goals are to balance them!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Method to create speech bubbles
  Widget _buildSpeechBubble(String text) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar only shows on the Landing Page
      appBar: _currentIndex == 1
          ? AppBar(
              title: const Text(
                'Food Bridge',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person, size: 40),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                ),
              ],
              backgroundColor: Colors.white,
              centerTitle: true,
            )
          : null,
      body: _getPage(_currentIndex), // Display content based on the selected index
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 70,
        items: const [
          Icon(Icons.fastfood, size: 40, color: Colors.green), // Map page icon
          Icon(Icons.home, size: 55, color: Colors.green),     // Home icon
          Icon(Icons.inventory, size: 40, color: Colors.green), // Inventory icon
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index to switch pages
          });
        },
      ),
    );
  }
}
