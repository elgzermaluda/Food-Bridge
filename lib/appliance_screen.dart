import 'package:flutter/material.dart';
import 'overview_screen.dart';

class ApplianceScreen extends StatefulWidget {
  final List<Map<String, dynamic>> rectangle1Items;
  final List<Map<String, dynamic>> rectangle2Items;

  const ApplianceScreen({
    super.key,
    required this.rectangle1Items,
    required this.rectangle2Items,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ApplianceScreenState createState() => _ApplianceScreenState();
}

class _ApplianceScreenState extends State<ApplianceScreen> {
  List<Map<String, dynamic>> selectedItems = [];

  // Nutritional values for food items (per 100 grams)
  final Map<String, double> nutritionalValues = {
    'Apple': 20.0,
    'Banana': 25.0,
    'Carrot': 30.0,
    'Tomato': 15.0,
  };

  IconData _getIconForFoodItem(String foodItem) {
    switch (foodItem) {
      case 'Apple':
        return Icons.apple;
      case 'Banana':
        return Icons.local_dining;
      case 'Carrot':
        return Icons.fastfood;
      case 'Tomato':
        return Icons.local_grocery_store;
      default:
        return Icons.help;
    }
  }

  void _updateSelectedItems(List<Map<String, dynamic>> items) {
    setState(() {
      selectedItems = items;
    });
  }

  // Calculate nutritional values based on selected items
  void _calculateNutritionalValue() {
    double totalNutritionalValue = 0.0;

    for (var item in selectedItems) {
      String foodName = item['name'];
      double quantity = double.tryParse(item['quantity'].toString()) ?? 0.0;

      // Get nutritional value for the food item
      double? nutritionalValue = nutritionalValues[foodName];

      if (nutritionalValue != null) {
        totalNutritionalValue += (nutritionalValue * quantity) / 100;
      }
    }

    // Determine meal equivalents
    int healthyMeals = (totalNutritionalValue / 30).floor(); // Assuming 30 value per meal
    int snacks = (totalNutritionalValue / 15).floor(); // Assuming 15 value per snack

    // Show the total nutritional value and meal equivalents
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Total Nutritional Value: ${totalNutritionalValue.toStringAsFixed(2)}\n'
          'Equivalent to: $healthyMeals healthy meal(s) or $snacks snack(s)',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Got Enough Nutritions?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: selectedItems.isEmpty
                    ? const Text('No items selected.')
                    : Wrap(
                        spacing: 10,
                        children: selectedItems.map((item) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              _getIconForFoodItem(item['name']),
                              color: Colors.green,
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            // Centering the buttons below the item selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OverviewScreen(
                          rectangle1Items: widget.rectangle1Items,
                          rectangle2Items: widget.rectangle2Items,
                          onConfirmSelection: _updateSelectedItems,
                        ),
                      ),
                    );
                  },
                  child: const Text('Add Food Items'),
                ),
                const SizedBox(width: 20), // Space between buttons
                ElevatedButton(
                  onPressed: _calculateNutritionalValue, // Call the calculation function
                  child: const Text('Calculate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
