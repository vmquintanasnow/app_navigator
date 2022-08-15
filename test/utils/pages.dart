import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  static const String path = 'page1';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Page1'),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  static const String path = 'page2';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Page2'),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  static const String path = 'page3';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Page3'),
    );
  }
}
