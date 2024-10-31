import 'package:flutter/material.dart';
import 'add_item_dialog.dart';
import 'appliance_screen.dart';
import 'expiring_items_screen.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {

  void _addItem(String rectangleName, Map<String, dynamic> item) {
    setState(() {
      if (rectangleName == 'Fridge') {
        Inventory().rectangle1Items.add(item);
      } else {
        Inventory().rectangle2Items.add(item);
      }
    });
  }

  void _updateItemQuantity(Map<String, dynamic> item, int newQuantity) {
    setState(() {
      item['quantity'] = newQuantity;
    });
  }

  void _deleteItem(Map<String, dynamic> item) {
    setState(() {
      if (Inventory().rectangle1Items.contains(item)) {
        Inventory().rectangle1Items.remove(item);
      } else {
        Inventory().rectangle2Items.remove(item);
      }
    });
  }

  List<Map<String, dynamic>> _getExpiringItems() {
    final now = DateTime.now();
    final threeDaysFromNow = now.add(const Duration(days: 3));

    final allItems = [
      ...Inventory().rectangle1Items,
      ...Inventory().rectangle2Items,
    ];

    final expiringItems = allItems.where((item) {
      final expiryDate = DateTime.parse(item['expiryDate']);
      return expiryDate.isBefore(threeDaysFromNow) && expiryDate.isAfter(now);
    }).toList();

    expiringItems.sort((a, b) {
      final dateA = DateTime.parse(a['expiryDate']);
      final dateB = DateTime.parse(b['expiryDate']);
      return dateA.compareTo(dateB);
    });

    return expiringItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.kitchen, size: 30),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ApplianceScreen(
                    rectangle1Items: Inventory().rectangle1Items,
                    rectangle2Items: Inventory().rectangle2Items,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, size: 30),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExpiringItemsScreen(items: _getExpiringItems()),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRectangle('Fridge', Inventory().rectangle1Items),
                    const SizedBox(height: 20),
                    _buildRectangle('Freezer', Inventory().rectangle2Items),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRectangle(String rectangleName, List<Map<String, dynamic>> items) {
    return Stack(
      children: [
        Container(
          width: 350,
          height: 250,
          decoration: BoxDecoration(
            color: rectangleName == 'Fridge' ? Colors.lightGreen[200] : Colors.lightGreen[300],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              rectangleName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Positioned(
          right: 15,
          top: 15,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddItemDialog(rectangleName: rectangleName);
                },
              ).then((value) {
                if (value != null) {
                  _addItem(rectangleName, value);
                }
              });
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.green),
              ),
              child: const Icon(Icons.add, size: 20, color: Colors.green),
            ),
          ),
        ),
        Positioned(
          left: 15,
          top: 60,
          child: Wrap(
            spacing: 8.0,
            children: items.map((item) {
              return FoodItemWidget(item: item, onTap: () {
                _showFoodItemDetails(item);
              });
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showFoodItemDetails(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  _editItemQuantity(item);
                },
                child: Text('Quantity: ${item['quantity']}', style: const TextStyle(fontSize: 16)),
              ),
              Text('Expiry Date: ${item['expiryDate']}'),
              Text('Description: ${item['description']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _deleteItem(item);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _editItemQuantity(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        int newQuantity = int.tryParse(item['quantity'].toString()) ?? 0;
        TextEditingController controller = TextEditingController(text: newQuantity.toString());
        return AlertDialog(
          title: const Text('Edit Quantity'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter new quantity',
            ),
            controller: controller,
            onChanged: (value) {
              newQuantity = int.tryParse(value) ?? newQuantity;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateItemQuantity(item, newQuantity);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class FoodItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const FoodItemWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.green),
        ),
        child: Center(
          child: Icon(_getIconForFoodItem(item['name']), size: 30, color: Colors.green),
        ),
      ),
    );
  }

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
      case 'Potato':
        return Icons.emoji_food_beverage;
      case 'Onion':
        return Icons.circle;
      case 'Lettuce':
        return Icons.grass;
      case 'Broccoli':
        return Icons.blur_circular;
      default:
        return Icons.help;
    }
  }
}

class Inventory {
  // Singleton instance
  static final Inventory _instance = Inventory._internal();

  // Internal lists to store items
  List<Map<String, dynamic>> rectangle1Items = []; // Fridge items
  List<Map<String, dynamic>> rectangle2Items = []; // Freezer items

  factory Inventory() {
    return _instance;
  }

  Inventory._internal(); // Private constructor
}
