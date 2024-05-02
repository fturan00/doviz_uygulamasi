import 'package:finans/doviz_veri_getir.dart';
import 'package:finans/product/padding_items.dart';
import 'package:finans/widget/main_page_widget/asset_row.dart';
import 'package:flutter/material.dart';

class FavoriteAssetPriceContainer extends StatefulWidget {
  const FavoriteAssetPriceContainer({
    super.key,
  });

  @override
  State<FavoriteAssetPriceContainer> createState() => _FavoriteAssetPriceContainerState();
}

DovizViewModel dovizViewModel = DovizViewModel();

class _FavoriteAssetPriceContainerState extends State<FavoriteAssetPriceContainer> {
  bool _showAllAssets = false;
  late List<DovizModel> dovizList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState;
    // TODO: implement initState
    loadDovizData();
  }

  void _toggleShowAllAssets() {
  setState(() {
    _showAllAssets = !_showAllAssets;
  });

}

   Future<void> loadDovizData() async {
    try {
      if (dovizList.isEmpty) {
        dovizList = await dovizViewModel.getDovizList();
      }
    } catch (error) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final double containerWidth = 30.0;
  final double containerHeight = 30.0;
  final String text1 = "Assets";
  final String text2 = "Price";
  final String text3 = "Balance";
  final String text8 = "Show all assets";

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ));
    }

    return Column(
      children: [
        Padding(
          padding: PaddingMain().paddingMain,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  text1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  text2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  text3,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
        _showAllAssets
            ? ListView(
                shrinkWrap: true,
                children: [
                  for (var doviz in dovizList.take(3))
                    AssetRow(
                      containerWidth: containerWidth,
                      containerHeight: containerHeight,
                      text4: doviz.name,
                      text5: doviz.buying.toString(),
                    ),
                  _ShowAllAssetButton(),
                ],
              )
            : Column(
                children: [
                  if (_showAllAssets == false && dovizList.isNotEmpty)
                    AssetRow(
                      containerWidth: containerWidth,
                      containerHeight: containerHeight,
                      text4: dovizList[0].name,
                      text5: dovizList[0].buying.toString(),
                    ),
                  _ShowAllAssetButton(),
                ],
              ),
      ],
    );
  }

  Row _ShowAllAssetButton() {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: PaddingMain().paddingTop,
                      child: Row(
                        children: [
                          Text(
                            text8,
                          ),
                          IconButton(
                            onPressed: _toggleShowAllAssets,
                            icon: Icon(
                              _showAllAssets
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 20,
                            ),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
  }
}
