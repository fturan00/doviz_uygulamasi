import 'package:finans/data.dart';
import 'package:finans/doviz_veri_getir.dart';
import 'package:finans/widget/main_page_widget/asset_price_container.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

const double containerWidth = 30.0;
const double containerHeight = 30.0;
const String text1 = "Assets";
const String text2 = "Price";
const String text3 = "Balance";
const String text8 = "Show all assets";
const String text9 = "Add";

class _PortfolioPageState extends State<PortfolioPage> {
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Portfolio"),
      ),
      body: PortfolioPageWidget(
        amountController: amountController,
        dovizViewModel: dovizViewModel,
      ),
    );
  }
}

class PortfolioPageWidget extends StatefulWidget {
  const PortfolioPageWidget({
    super.key,
    required this.amountController,
    required this.dovizViewModel,
  });
  final DovizViewModel dovizViewModel;
  final TextEditingController amountController;

  @override
  State<PortfolioPageWidget> createState() => _PortfolioPageWidgetState();
}

class _PortfolioPageWidgetState extends State<PortfolioPageWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DovizModel>>(
      future: widget.dovizViewModel.getDovizList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DovizModel> dovizList = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                const _TitleWidget(),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: dovizList.length,
                    itemBuilder: (context, index) {
                      DovizModel dovizModel = dovizList[index];
                      return ItemWidget(
                        amountController: widget.amountController,
                        dovizModel: dovizModel,
                      );
                    })
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              text1,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              text2,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              text3,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              text9,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

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
