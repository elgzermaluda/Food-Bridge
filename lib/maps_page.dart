import 'package:flutter/material.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  bool isHelp = false; // State to track if user needs help
  final TransformationController _controller = TransformationController();

  // Original position of the user
  final Offset _userPosition = const Offset(110, 200);

  // NGO positions
  final List<Offset> _ngoPositions = [
    const Offset(180, 300),  // NGO 1
    const Offset(350, 350),  // NGO 2
  ];

  // Users needing help positions
  final List<Offset> _helpNeededPositions = [
    const Offset(200, 250),  // User needing help 1
    const Offset(100, 150),  // User needing help 2
  ];

  @override
  void initState() {
    super.initState();
    // Set an initial scale for a closer view on the image
    _controller.value = Matrix4.identity()..scale(1.5); // Adjust scale factor as needed
  }

  void toggleHelpStatus() {
    setState(() {
      isHelp = !isHelp; // Toggle between help and normal user icon
    });
  }

  // Function to reset the view to the current user location
  void resetView() {
    // Set the transformation to center on the user's position with the initial scale
    _controller.value = Matrix4.identity()
      ..scale(1.5) // Maintain the initial zoom level
      ..translate(-_userPosition.dx + 100, -_userPosition.dy + 150);
  }

  // Function to find the nearest NGO
  void findNearestNgo() {
    Offset? nearestNgo;
    double nearestDistance = double.infinity;

    for (final ngoPosition in _ngoPositions) {
      final distance = (_userPosition - ngoPosition).distance;
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestNgo = ngoPosition;
      }
    }

    if (nearestNgo != null) {
      _controller.value = Matrix4.identity()
        ..scale(1.5) // Keep the zoom level consistent
        ..translate(-nearestNgo.dx + 100, -nearestNgo.dy + 120);
    }
  }

  // Function to find the nearest user needing help
  void findNearestHelpNeeded() {
    Offset? nearestHelpNeeded;
    double nearestDistance = double.infinity;

    for (final helpNeededPosition in _helpNeededPositions) {
      final distance = (_userPosition - helpNeededPosition).distance;
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestHelpNeeded = helpNeededPosition;
      }
    }

    if (nearestHelpNeeded != null) {
      _controller.value = Matrix4.identity()
        ..scale(1.5) // Keep the zoom level consistent
        ..translate(-nearestHelpNeeded.dx + 100, -nearestHelpNeeded.dy + 200);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bridge Map', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[50], // Match the background color
        centerTitle: true, // Center the title
      ),
      backgroundColor: Colors.blue[50],

      body: Stack(
        children: [
          // Draggable map area with background image
          InteractiveViewer(
            transformationController: _controller,
            maxScale: 2.5,
            minScale: 0.5,
            boundaryMargin: const EdgeInsets.all(400),
            child: Container(
              width: 5000, // Increased the width for a larger background area
              height: 5000, // Increased the height for a larger background area
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/penang.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: _userPosition.dx,
                    top: _userPosition.dy,
                    child: IconButton(
                      icon: Icon(
                        isHelp ? Icons.warning : Icons.location_pin, 
                        size: 40,
                        color: isHelp ? Colors.red : Colors.blue,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isHelp
                                ? 'You are requesting help!'
                                : 'You are here!'),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: _ngoPositions[0].dx,
                    top: _ngoPositions[0].dy,
                    child: IconButton(
                      icon: const Icon(Icons.local_hospital, size: 40, color: Colors.green),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('NGO - Location 1')),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: _ngoPositions[1].dx,
                    top: _ngoPositions[1].dy,
                    child: IconButton(
                      icon: const Icon(Icons.local_hospital, size: 40, color: Colors.green),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('NGO - Location 2')),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: _helpNeededPositions[0].dx,
                    top: _helpNeededPositions[0].dy,
                    child: IconButton(
                      icon: const Icon(Icons.warning, size: 40, color: Colors.red),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User needing help - Location 1')),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: _helpNeededPositions[1].dx,
                    top: _helpNeededPositions[1].dy,
                    child: IconButton(
                      icon: const Icon(Icons.warning, size: 40, color: Colors.red),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User needing help - Location 2')),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 60,
                    top: 250,
                    child: IconButton(
                      icon: const Icon(Icons.location_pin, size: 40, color: Colors.blue),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Normal User - Location 1')),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 230,
                    top: 170,
                    child: IconButton(
                      icon: const Icon(Icons.location_pin, size: 40, color: Colors.blue),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Normal User - Location 2')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildMinimalistButton(
                          label: isHelp ? 'Stop Help' : 'I Need Help!',
                          icon: isHelp ? Icons.stop : Icons.warning,
                          onPressed: toggleHelpStatus,
                          isHelpButton: isHelp,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMinimalistButton(
                          label: 'Nearest NGO',
                          icon: Icons.local_hospital,
                          onPressed: findNearestNgo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildMinimalistButton(
                          label: 'People in Need',
                          icon: Icons.warning,
                          onPressed: findNearestHelpNeeded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMinimalistButton(
                          label: 'Reset View',
                          icon: Icons.refresh,
                          onPressed: resetView,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalistButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isHelpButton = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 35),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: isHelpButton ? Colors.white : Colors.blue,
        backgroundColor: isHelpButton ? Colors.red : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        elevation: 5,
      ),
    );
  }
}
