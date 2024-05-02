import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finans/doviz_veri_getir.dart';
import 'package:finans/pages/portfolio_page_view.dart';
import 'package:finans/widget/portfolio_page_widget/show_dialog_widget.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatefulWidget {
  final DovizModel dovizModel;
  final TextEditingController amountController;

  const ItemWidget({
    Key? key,
    required this.amountController,
    required this.dovizModel,
  }) : super(key: key);

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  late double balance;
  

  @override
  void initState() {
    super.initState();
    balance = 0;
    _getBalance();
  }

  void _getBalance() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('balances')
        .doc(widget.dovizModel.name)
        .get();

    if (snapshot.exists) {
      setState(() {
        balance = (snapshot.data() as Map<String, dynamic>)['balance'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              widget.dovizModel.name,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              widget.dovizModel.buying.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              balance.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                ShowDialogAmount()
                    .showAddAmountDialog(context, widget.amountController,
                        (double enteredAmount) async {
                  double updatedBalance = balance + enteredAmount;
                  setState(() {
                    balance = updatedBalance;
                  });
                  await FirebaseFirestore.instance
                      .collection('balances')
                      .doc(widget.dovizModel.name)
                      .set({'balance': updatedBalance});
                }, (double enteredAmount) async {
                  if (enteredAmount <= balance) {
                    double updatedBalance = balance - enteredAmount;
                    setState(() {
                      balance = updatedBalance;
                    });
                    await FirebaseFirestore.instance
                        .collection('balances')
                        .doc(widget.dovizModel.name)
                        .set({'balance': updatedBalance});
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          title: const Text("Error"),
                          content: const Text(
                              "Girdiğin değer portfolio değerinden daha büyük"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}