import 'package:flutter/material.dart';

class ShowDialogAmount {
  void showAddAmountDialog(
      BuildContext context,
      TextEditingController amountController,
      Function(double) onAdd,
      Function(double) onRemove) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: const Text("Add-Remove Amount"),
          content: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: "Enter amount"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                double enteredAmount = double.parse(amountController.text);
                onAdd(enteredAmount);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                double enteredAmount = double.parse(amountController.text);
                
                onRemove(enteredAmount);
                Navigator.pop(context);
              },
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );
  }
}
