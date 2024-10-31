import 'package:flutter/material.dart';

class FoodItemDetailDialog extends StatelessWidget {
  final String foodItem;

  const FoodItemDetailDialog({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;

    return AlertDialog(
      title: Text(
        'Details for $foodItem',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.green,
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(quantityController, 'Quantity (grams or kg)', TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField(descriptionController, 'Description', TextInputType.text),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  // Show date picker to select expiry date
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(), // Ensure selection starts from today
                    lastDate: DateTime(2101), // Maximum selectable date
                  );

                  // Update selectedDate if the picked date is not null and valid
                  if (pickedDate != null) {
                    selectedDate = pickedDate; // Assign the selected date
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    // ignore: unnecessary_null_comparison
                    selectedDate == null
                        ? 'Select Expiry Date'
                        : 'Expiry Date: ${selectedDate.toLocal().toIso8601String().split('T')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red[200],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle save functionality here
            final quantity = quantityController.text;
            final description = descriptionController.text;

            if (quantity.isNotEmpty && selectedDate != null) {
              // Return the collected data to the parent or handle as needed
              Navigator.of(context).pop({
                'quantity': quantity,
                'description': description,
                'expiryDate': selectedDate,
              });
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType inputType) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.green[50],
      ),
      keyboardType: inputType,
      style: const TextStyle(fontSize: 16),
    );
  }
}
