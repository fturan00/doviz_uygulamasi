
import 'package:finans/doviz_veri_getir.dart';
import 'package:finans/widget/main_page_widget/asset_price_container.dart';
import 'package:finans/widget/portfolio_page_widget/item_widget.dart';
import 'package:finans/widget/portfolio_page_widget/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

const double containerWidth = 30.0;
const double containerHeight = 30.0;
const String text1 = "Dövizler";
const String text2 = "Alış";
const String text3 = "Değeri";
const String text9 = "Ekle";

class _PortfolioPageState extends State<PortfolioPage> {
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Portfolyö"),
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
                TitleWidget(),
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

