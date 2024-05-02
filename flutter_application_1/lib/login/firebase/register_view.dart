import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finans/login/firebase/login_service.dart';
import 'package:finans/product/login_strings.dart';
import 'package:finans/login/firebase/login_view.dart';
import 'package:finans/pages/main_page_view.dart';
import 'package:finans/widget/circular__progress_indicator.dart';
import 'package:finans/widget/login_sizedbox.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key, required this.authService}) : super(key: key);
  final AuthService authService;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameRegisterController = TextEditingController();
  final TextEditingController _emailRegisterController =
      TextEditingController();
  final TextEditingController _passwordRegisterController =
      TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt Ekranı"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.account_box,
              size: 100,
            ),
            Text(LoginStrings().welcomeRegister),
            Column(
              children: [
                _RegisterNameArea(controller: _nameRegisterController),
                const SizedBoxLogin(),
                _RegisterEmailArea(controller: _emailRegisterController),
                const SizedBoxLogin(),
                _RegisterPasswordArea(controller: _passwordRegisterController),
              ],
            ),
            _registerButton(),
            if (_isLoading) const CircularProgress()
          ],
        ),
      ),
    );
  }

  ElevatedButton _registerButton() {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(double.infinity, 50),
        ),
      ),
      onPressed: _isLoading ? null : _register,
      child: Text(LoginStrings().registerText),
    );
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.authService.createAccount(_emailRegisterController.text,
          _passwordRegisterController.text, _nameRegisterController.text);
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    authService: authService,
                  )));
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

class _RegisterNameArea extends StatelessWidget {
  final TextEditingController controller;

  const _RegisterNameArea({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        labelText: LoginStrings().nameArea,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _RegisterPasswordArea extends StatelessWidget {
  final TextEditingController controller;

  const _RegisterPasswordArea({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      autofocus: true,
      decoration: InputDecoration(
        labelText: LoginStrings().passwordArea,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _RegisterEmailArea extends StatelessWidget {
  final TextEditingController controller;

  const _RegisterEmailArea({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: LoginStrings().emailArea,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
