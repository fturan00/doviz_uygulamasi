import 'package:finans/service/doviz_veri_getir.dart';
import 'package:finans/product/padding_items.dart';
import 'package:flutter/material.dart';

class ButtonRowContainer extends StatefulWidget {
  const ButtonRowContainer({
    super.key,
  });

  @override
  State<ButtonRowContainer> createState() => ButtonRowContainerState();
}

DovizRepository dovizRepository = DovizRepository();

class ButtonRowContainerState extends State<ButtonRowContainer> {
  final String allAssets = 'Tümü (10)';
  final String search = 'Ara';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingMain().paddingMain,
      child: Row(
        children: [
          IconButton(
            onPressed: () {

            },
            icon: Row(
              children: [
                Text(allAssets),
              ],
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
              },
              icon: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    size: 20,
                  ),
                  Text(
                    search,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
