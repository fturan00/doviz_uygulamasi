import 'package:finans/product/padding_items.dart';
import 'package:flutter/material.dart';

class AssetRow extends StatelessWidget {
  const AssetRow({
    super.key,
    required this.containerWidth,
    required this.containerHeight,
    required this.text4,
    required this.text5,
  });

  final double containerWidth;
  final double containerHeight;
  final String text4;
  final String text5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingMain().paddingMain,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: SizedBox(
                width: containerWidth,
                height: containerHeight,
                child: Image.asset(
                  "assets/images/dolar.png",
                )),
          ),
          Expanded(
              child: Text(
            text4,
            textAlign: TextAlign.center,
          )),
          Expanded(
              child: Text(
            text5,
            textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }
}