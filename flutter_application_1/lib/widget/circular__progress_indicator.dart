import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  final Color colorIndicator = Colors.red;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: colorIndicator,
    );
  }
}
