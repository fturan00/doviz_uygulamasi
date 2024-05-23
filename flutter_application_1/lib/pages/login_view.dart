import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finans/service/login_service.dart';
import 'package:finans/product/login_strings.dart';
import 'package:finans/pages/register_view.dart';
import 'package:finans/pages/main_page_view.dart';
import 'package:finans/widget/circular__progress_indicator.dart';
import 'package:finans/widget/login_sizedbox.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.authService});
  final AuthService authService;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Giriş Ekranı",
          style: TextStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.login,
              size: 100,
            ),
            Text(LoginStrings().welcomeString),
            Column(
              children: [
                _LoginMailArea(
                  controller: _emailController,
                ),
                const SizedBoxLogin(),
                _LoginPasswordArea(
                  controller: _passwordController,
                ),
              ],
            ),
            Column(
              children: [
                _loginButton(),
                const _RegisterButton(),
              ],
            ),
            if (_isLoading) const CircularProgress()
          ],
        ),
      ),
    );
  }

  ElevatedButton _loginButton() {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(double.infinity, 50),
        ),
      ),
      onPressed: _isLoading ? null : _login,
      child: Text(LoginStrings().loginButton),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.authService
          .signIn(_emailController.text, _passwordController.text);
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => const MainPage())));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = "Bir hata ile karşılaşıldı.";

      if (e is FirebaseException) {
        switch (e.code) {
          case 'network-request-failed':
            errorMessage = "Bağlantı hatası. İnternet bağlantını kontrol et";
            break;
          case 'invalid-email':
          case 'wrong-password':
            errorMessage = "Geçersiz e-posta veya şifre.";
            break;
          default:
            errorMessage = "Bir hata oluştu: ${e.message}";
            break;
        }
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Hata"),
              content: Text(errorMessage),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Kapat"))
              ],
            );
          });
    }
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterView(
                        authService: authService,
                      )));
        },
        child: Text(LoginStrings().registerText));
  }
}

class _LoginMailArea extends StatelessWidget {
  const _LoginMailArea({
    required this.controller,
  });
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          label: Text(LoginStrings().emailArea),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}

class _LoginPasswordArea extends StatelessWidget {
  const _LoginPasswordArea({
    required this.controller,
  });
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
          label: Text(LoginStrings().passwordArea),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}
