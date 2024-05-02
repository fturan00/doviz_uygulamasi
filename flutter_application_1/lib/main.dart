import 'package:finans/firebase_options.dart';
import 'package:finans/login/firebase/login_service.dart';
import 'package:finans/pages/assets_page_view.dart';
import 'package:finans/pages/main_page_view.dart';
import 'package:finans/pages/portfolio_page_view.dart';
import 'package:finans/product/color_items.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final AuthService authService = AuthService();
  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class AppThemeCustom {
  ThemeData get theme => ThemeData(
      colorScheme: const ColorScheme.light(
        error: Colors.red,
        secondary: Color(0xff0b2e40),
        onSecondary: ColorItems.stromyGrey,
      ),
      appBarTheme:
          const AppBarTheme(backgroundColor: Colors.red, elevation: 0));
}
