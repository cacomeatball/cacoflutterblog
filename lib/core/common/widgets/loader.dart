import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 15,
        child: Image.asset(
          'lib/assets/cacodemon-spinning.gif',
          height: 50,
          width: 50,
          ),
      );
  }
}