import 'package:flutter/material.dart';

import '../widgets/signin.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  int currentIndex = 0;

  void onChangeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  late final List<Widget> _children = [
    SignIn(changeIndex: onChangeIndex),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 360,
                ),
                child: _children[currentIndex],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
