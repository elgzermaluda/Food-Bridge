// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Map<String, dynamic>> fridgeItems = [];
  List<Map<String, dynamic>> freezerItems = [];

  void _addItem(String item, String quantity, String description, DateTime expiryDate, bool isFridge) {
    final newItem = {
      'item': item,
      'quantity': quantity,
      'description': description,
      'expiryDate': expiryDate,
    };
    
    setState(() {
      if (isFridge) {
        fridgeItems.add(newItem);
      } else {
        freezerItems.add(newItem);
      }
    });
  }

  void _showAddDetailsDialog(BuildContext context, bool isFridge) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime? expiryDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Details for Food Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity (grams/kg)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(expiryDate == null
                        ? 'Select Expiry Date'
                        : 'Expiry Date: ${expiryDate!.toLocal()}'.split(' ')[0]),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != expiryDate) {
                          setState(() {
                            expiryDate = pickedDate;
                          });
                        }
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (quantityController.text.isNotEmpty && descriptionController.text.isNotEmpty && expiryDate != null) {
                  _addItem(
                    'Food Item',  // Change this to the selected food item
                    quantityController.text,
                    descriptionController.text,
                    expiryDate!,
                    isFridge,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Fridge Section
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Fridge', style: TextStyle(fontSize: 24)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddDetailsDialog(context, true),
                    ),
                  ],
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.lightGreen[100],
                  child: ListView.builder(
                    itemCount: fridgeItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${fridgeItems[index]['item']} (${fridgeItems[index]['quantity']})'),
                        subtitle: Text('Description: ${fridgeItems[index]['description']} - Expiry: ${fridgeItems[index]['expiryDate']?.toLocal()}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Freezer Section
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Freezer', style: TextStyle(fontSize: 24)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddDetailsDialog(context, false),
                    ),
                  ],
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.lightBlue[100],
                  child: ListView.builder(
                    itemCount: freezerItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${freezerItems[index]['item']} (${freezerItems[index]['quantity']})'),
                        subtitle: Text('Description: ${freezerItems[index]['description']} - Expiry: ${freezerItems[index]['expiryDate']?.toLocal()}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
