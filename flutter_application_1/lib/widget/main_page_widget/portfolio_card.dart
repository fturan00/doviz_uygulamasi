import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finans/doviz_veri_getir.dart';
import 'package:finans/product/color_items.dart';
import 'package:finans/product/padding_items.dart';
import 'package:flutter/material.dart';

class PortfolioCard extends StatefulWidget {
  const PortfolioCard({
    super.key,
  });

  @override
  State<PortfolioCard> createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard> {
  final String text1 = "Total balance";

  final String text2 = "17,475";

  final String text3 = "Total balance";

  final String text4 = "+2,754";

  final String text5 = "%2,75";

  final String text6 = "TRY";
  late double balanceTotal;
  late double previousBalanceTotal;
  void initState() {
    super.initState();
    previousBalanceTotal = 0;
    balanceTotal = 0;
    _getBalance();
  }

  void _getBalance() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("balances").get();

    double total = 0;

    querySnapshot.docs.forEach((DocumentSnapshot document) {
      if (document.exists) {
        total += (document.data() as Map<String, dynamic>)["balance"] ?? 0;
      }
    });

    previousBalanceTotal = total;

    setState(() {
      previousBalanceTotal = balanceTotal; 
      balanceTotal = total;
    });
  }

  String getAddedAmount() {
    double addedAmount = balanceTotal - previousBalanceTotal;
    if (addedAmount >= 0) {
      return "+\$${addedAmount.toStringAsFixed(2)}";
    } else {
      return "-\$${(addedAmount * -1).toStringAsFixed(2)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingMain().paddingMain,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: PaddingMain().paddingMain,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text1),
                  Row(
                    children: [
                      Text(
                        balanceTotal.toString(),
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: PaddingMain().paddingTop,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: PaddingMain().paddingLeft,
                              child: Text(text6),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(getAddedAmount()),
                      Padding(
                        padding: PaddingMain().paddingLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorItems.greenMain,
                          ),
                          child: Text(
                            text5,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Card(),
          ],
        ),
      ),
    );
  }
}
