import 'package:flutter/material.dart';

class OverviewScreen extends StatefulWidget {
  final List<Map<String, dynamic>> rectangle1Items;
  final List<Map<String, dynamic>> rectangle2Items;
  final Function(List<Map<String, dynamic>>) onConfirmSelection;

  const OverviewScreen({
    super.key,
    required this.rectangle1Items,
    required this.rectangle2Items,
    required this.onConfirmSelection,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final List<Map<String, dynamic>> selectedItems = [];

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

  @override
  Widget build(BuildContext context) {
    final allItems = [...widget.rectangle1Items, ...widget.rectangle2Items];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview of Food Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onConfirmSelection(selectedItems);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: allItems.isEmpty
            ? const Center(child: Text('No food items added.'))
            : ListView.builder(
                itemCount: allItems.length,
                itemBuilder: (context, index) {
                  final item = allItems[index];
                  final isSelected = selectedItems.contains(item);

                  return ListTile(
                    leading: Container(
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
                    ),
                    title: Text(item['name']),
                    subtitle: Text(
                        'Quantity: ${item['quantity']} - Expiry: ${item['expiryDate']}'),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            selectedItems.add(item);
                          } else {
                            selectedItems.remove(item);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
