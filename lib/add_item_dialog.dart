import 'package:flutter/material.dart';
import 'package:todo_app/food_.dart';

class AddItemDialog extends StatefulWidget {
  final String rectangleName;

  const AddItemDialog({super.key, required this.rectangleName});

  @override
  // ignore: library_private_types_in_public_api
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  String selectedItem = '';

  Future<void> _openFoodDetailsDialog(String itemName) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FoodDetailsDialog(itemName: itemName),
    );

    if (result != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop({
        'name': itemName,
        ...result,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded corners
      title: Text(
        'Add Food Item to ${widget.rectangleName}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // To ensure the content is centered
          children: [
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              alignment: WrapAlignment.center, // Center the buttons
              children: [
                _buildFoodButton(context, 'Apple', Icons.apple),
                _buildFoodButton(context, 'Banana', Icons.local_dining),
                _buildFoodButton(context, 'Carrot', Icons.fastfood),
                _buildFoodButton(context, 'Tomato', Icons.local_grocery_store),
                _buildFoodButton(context, 'Potato', Icons.emoji_food_beverage),
                _buildFoodButton(context, 'Onion', Icons.circle),
                _buildFoodButton(context, 'Lettuce', Icons.grass),
                _buildFoodButton(context, 'Broccoli', Icons.blur_circular),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildFoodButton(BuildContext context, String itemName, IconData icon) {
    return GestureDetector(
      onTap: () => _openFoodDetailsDialog(itemName),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 85, // Increased width
          height: 85, // Increased height
          decoration: BoxDecoration(
            color: Colors.green[600], // Darker green
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 5),
              Text(
                itemName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center the text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
