import 'package:flutter/material.dart';

class FoodDetailsDialog extends StatefulWidget {
  final String itemName;

  const FoodDetailsDialog({super.key, required this.itemName});

  @override
  // ignore: library_private_types_in_public_api
  _FoodDetailsDialogState createState() => _FoodDetailsDialogState();
}

class _FoodDetailsDialogState extends State<FoodDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  String quantity = '';
  String expiryDate = '';
  String description = '';

  // Date picker for expiry date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        expiryDate = "${picked.toLocal()}".split(' ')[0]; // Format as "YYYY-MM-DD"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Details for ${widget.itemName}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity (grams/kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    quantity = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: expiryDate.isEmpty ? 'Select a date' : expiryDate,
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (expiryDate.isEmpty) {
                        return 'Please select an expiry date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Description (optional)'),
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close without adding
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop({
                'quantity': quantity,
                'expiryDate': expiryDate,
                'description': description,
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
