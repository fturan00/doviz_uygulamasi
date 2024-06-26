import 'package:finans/service/doviz_veri_getir.dart';
import 'package:finans/product/padding_items.dart';
import 'package:finans/widget/main_page_widget/asset_row.dart';
import 'package:flutter/material.dart';

class AssetPriceContainer extends StatefulWidget {
  const AssetPriceContainer({
    super.key,
  });

  @override
  State<AssetPriceContainer> createState() => _AssetPriceContainerState();
}

DovizViewModel dovizViewModel = DovizViewModel();

class _AssetPriceContainerState extends State<AssetPriceContainer> {
  bool _showAllAssets = false;
  late List<DovizModel> dovizList = [];
  bool _isLoading = true;

  void didChangeDependencies() {
    super.didChangeDependencies();
    loadDovizData();
  }

  void _toggleShowAllAssets() {
    setState(() {
      _showAllAssets = !_showAllAssets;
      _isLoading = false;
    });

    if (dovizList.isEmpty) {
      loadDovizData();
    }
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
  final String text1 = "Dövizler";
  final String text2 = "Alış";
  final String text3 = "Satış";
  final String text8 = "Daha fazla göster";

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: Padding(
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
                      text6: doviz.selling.toString()
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
                        text6: dovizList[0].selling.toString()),
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
