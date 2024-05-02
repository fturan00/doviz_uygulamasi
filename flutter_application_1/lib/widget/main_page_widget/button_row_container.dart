import 'package:finans/doviz_veri_getir.dart';
import 'package:finans/product/padding_items.dart';
import 'package:flutter/material.dart';

class ButtonRowContainer extends StatefulWidget {
  const ButtonRowContainer({
    super.key,
    required this.toggleShowFavorites,
    required this.showFavorites,
  });

  final bool showFavorites;
  final VoidCallback toggleShowFavorites;

  @override
  State<ButtonRowContainer> createState() => ButtonRowContainerState();
}

DovizRepository dovizRepository = DovizRepository();

class ButtonRowContainerState extends State<ButtonRowContainer> {
  final String allAssets = 'All Assets (10)';
  final String favorites = 'Favorites';
  final String search = 'Search';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingMain().paddingMain,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (widget.showFavorites) {
                widget.toggleShowFavorites();
              }
            },
            icon: Row(
              children: [
                Text(allAssets),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (!widget.showFavorites) {
                widget.toggleShowFavorites();
              }
            },
            icon: Row(
              children: [
                Text(favorites),
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
