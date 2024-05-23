import 'package:finans/pages/assets_page_view.dart';
import 'package:finans/service/login_service.dart';
import 'package:finans/pages/login_view.dart';
import 'package:finans/pages/portfolio_page_view.dart';
import 'package:finans/product/padding_items.dart';
import 'package:finans/widget/main_page_widget/asset_price_container.dart';
import 'package:finans/widget/main_page_widget/button_row_container.dart';
import 'package:finans/widget/main_page_widget/portfolio_card.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key});

  @override
  State<MainPage> createState() => _MainPageState();
}

final AuthService authService = AuthService();
AuthService _auth = AuthService();

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          _signOutButton(context: context),
        ],
      ),
      body: _MainPageColumn(),
    );
  }
}

class _signOutButton extends StatelessWidget {
  const _signOutButton({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _auth.signOut().then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => LoginPage(authService: authService)),
            ),
          );
        });
      },
      icon: const Icon(Icons.logout),
    );
  }
}

class _MainPageColumn extends StatelessWidget {
  const _MainPageColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: PaddingMain().paddingMain,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PortfolioPage()));
                },
                icon: const Row(
                  children: [
                    Text(
                      "Portfolyö",
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AssetsPage()));
                },
                icon: const Row(
                  children: [
                    Text("Dövizler",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const PortfolioCard(),
        Padding(
          padding: PaddingMain().paddingMain,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Dövizler",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ),
        ButtonRowContainer(),
        AssetPriceContainer(),
      ],
    );
  }
}
