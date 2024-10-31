import 'package:flutter/material.dart';

class ExpiringItemsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ExpiringItemsScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiring Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: items.isEmpty
            ? const Center(child: Text('No items expiring soon.'))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text('Expires on: ${item['expiryDate']}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
