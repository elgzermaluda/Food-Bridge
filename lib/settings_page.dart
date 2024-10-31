import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selectedUserType = 'Regular User'; // Default user type

  // List of user types
  final List<String> _userTypes = [
    'NGO/Food Bank/Restaurant',
    'Regular User',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Profile Picture
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://www.example.com/profile_pic.png', // Replace with actual image URL
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'John Doe', // Replace with actual user name
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            const Center(
              child: Text(
                'Verified User', // Status can be dynamic
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            // User Type Dropdown
            const Text(
              'User Type:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            DropdownButton<String>(
              value: _selectedUserType,
              isExpanded: true,
              items: _userTypes.map((String userType) {
                return DropdownMenuItem<String>(
                  value: userType,
                  child: Text(userType),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUserType = newValue; // Update the selected user type
                });
              },
            ),
            const SizedBox(height: 20),
            // Additional Settings
            const Text(
              'Additional Settings:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {
                // Handle change password action
              },
            ),
            ListTile(
              title: const Text('Notification Settings'),
              onTap: () {
                // Handle notification settings action
              },
            ),
            const SizedBox(height: 20),
            // Log Out Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle log out action
                },
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
