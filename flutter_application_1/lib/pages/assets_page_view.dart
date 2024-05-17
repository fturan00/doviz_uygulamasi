import 'package:finans/doviz_veri_getir.dart';
import 'package:finans/product/padding_items.dart';
import 'package:finans/widget/main_page_widget/asset_price_container.dart';
import 'package:flutter/material.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({Key? key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

const double containerWidth = 30.0;
const double containerHeight = 30.0;

const String text1 = "Dövizler";
const String text2 = "Alış";
const String text3 = "Satış";

class _AssetsPageState extends State<AssetsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(text1),
      ),
      body: AssetPageWidget(dovizViewModel: dovizViewModel),
    );
  }
}

class AssetPageWidget extends StatelessWidget {
  final DovizViewModel dovizViewModel;
  const AssetPageWidget({
    super.key,
    required this.dovizViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return _AssetsPageFutureBuilderWidget(dovizViewModel: dovizViewModel);
  }
}

class _AssetsPageFutureBuilderWidget extends StatelessWidget {
  const _AssetsPageFutureBuilderWidget({
    super.key,
    required this.dovizViewModel,
  });

  final DovizViewModel dovizViewModel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DovizModel>>(
      future: dovizViewModel.getDovizList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DovizModel> dovizList = snapshot.data!;
          return _AssetPageScrollWidget(dovizList: dovizList);
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class _AssetPageScrollWidget extends StatelessWidget {
  const _AssetPageScrollWidget({
    super.key,
    required this.dovizList,
  });

  final List<DovizModel> dovizList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: PaddingMain().paddingMain,
          child: const Row(
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
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: dovizList.length,
            itemBuilder: (context, index) {
              DovizModel dovizModel = dovizList[index];
              return ItemWidget(dovizModel: dovizModel);
            },
          ),
        ),
      ],
    );
  }
}

class ItemWidget extends StatelessWidget {
  final DovizModel dovizModel;
  ItemWidget({Key? key, required this.dovizModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingMain().paddingMain,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              dovizModel.name,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              dovizModel.buying.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              dovizModel.selling.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
