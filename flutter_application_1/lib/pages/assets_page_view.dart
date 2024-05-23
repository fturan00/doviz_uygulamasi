import 'package:finans/service/doviz_veri_getir.dart';
import 'package:finans/product/padding_items.dart';
import 'package:flutter/material.dart';
import 'package:finans/service/doviz_storage.dart';
import 'package:flutter/widgets.dart'; 

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
  late Future<List<DovizModel>> _futureDovizList;
  List<DovizModel>? _initialDovizList;
  late DovizViewModel dovizViewModel;
  late DovizStorage dovizStorage; 

  @override
  void initState() {
    super.initState();
    dovizViewModel = DovizViewModel();
    dovizStorage = DovizStorage();
    _loadInitialDovizList();
    _futureDovizList = dovizViewModel.getDovizList();
    _futureDovizList.then((dovizList) {
      dovizStorage.saveInitialDovizList(dovizList);
    });
  }

  Future<void> _loadInitialDovizList() async {
    List<DovizModel>? dovizList = await dovizStorage.loadInitialDovizList();
    setState(() {
      _initialDovizList = dovizList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(text1),
      ),
      body: AssetPageWidget(
        futureDovizList: _futureDovizList,
        initialDovizList: _initialDovizList,
      ),
    );
  }
}

class AssetPageWidget extends StatelessWidget {
  final Future<List<DovizModel>> futureDovizList;
  final List<DovizModel>? initialDovizList;

  const AssetPageWidget({
    super.key,
    required this.futureDovizList,
    this.initialDovizList,
  });

  @override
  Widget build(BuildContext context) {
    return _AssetsPageFutureBuilderWidget(
      futureDovizList: futureDovizList,
      initialDovizList: initialDovizList,
    );
  }
}

class _AssetsPageFutureBuilderWidget extends StatelessWidget {
  final Future<List<DovizModel>> futureDovizList;
  final List<DovizModel>? initialDovizList;

  const _AssetsPageFutureBuilderWidget({
    super.key,
    required this.futureDovizList,
    this.initialDovizList,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DovizModel>>(
      future: futureDovizList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DovizModel> dovizList = snapshot.data!;
          return _AssetPageScrollWidget(
            dovizList: dovizList,
            initialDovizList: initialDovizList,
          );
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
  final List<DovizModel> dovizList;
  final List<DovizModel>? initialDovizList;

  const _AssetPageScrollWidget({
    super.key,
    required this.dovizList,
    this.initialDovizList,
  });

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
        _AssetPageListView(dovizList: dovizList, initialDovizList: initialDovizList),
      ],
    );
  }
}

class _AssetPageListView extends StatelessWidget {
  const _AssetPageListView({
    super.key,
    required this.dovizList,
    required this.initialDovizList,
  });

  final List<DovizModel> dovizList;
  final List<DovizModel>? initialDovizList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: dovizList.length,
        itemBuilder: (context, index) {
          DovizModel dovizModel = dovizList[index];
          DovizModel? initialDovizModel = initialDovizList?.firstWhere(
            (element) => element.name == dovizModel.name,
            orElse: () => DovizModel(name: '', buying: 0.0, selling: 0.0),
          );
          return ItemWidget(
            dovizModel: dovizModel,
            initialDovizModel: initialDovizModel,
          );
        },
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final DovizModel dovizModel;
  final DovizModel? initialDovizModel;

  ItemWidget({Key? key, required this.dovizModel, this.initialDovizModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData? icon;
    if (initialDovizModel != null &&
        initialDovizModel!.buying != null &&
        dovizModel.buying != null) {
      if (dovizModel.buying! > initialDovizModel!.buying!) {
        icon = Icons.arrow_upward;
      } else if (dovizModel.buying! < initialDovizModel!.buying!) {
        icon = Icons.arrow_downward;
      }
    }

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
            child: Padding(
              padding: PaddingMain().paddingMain,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      dovizModel.buying?.toString() ?? '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (icon != null) Expanded(child: Icon(icon, size: 16.0)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Text(
              dovizModel.selling?.toString() ?? '',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
