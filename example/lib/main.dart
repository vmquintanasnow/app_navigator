import 'package:app_navigator/app_navigator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppNavigator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationLayer(
        initPage: Page1(),
        initPath: Page1.route,
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  static const String route = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Page_1'),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                AppNavigator().currentPath ?? 'no path',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w200),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(AppNavigator()
                  .navigationTree
                  .fold('Stack', (initial, value) => '$initial -> $value')),
              ElevatedButton(
                child: Text('Go to Page 2'),
                onPressed: () =>
                    AppNavigator().push(Page2(), name: Page2.route),
              ),
              ElevatedButton(
                child: Text('Push replacement'),
                onPressed: () => AppNavigator()
                    .pushAndReplaceAllStack(Page2(), name: Page2.route),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  static const String route = 'page2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Page_2'),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                AppNavigator().currentPath ?? 'no path',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w200),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(AppNavigator()
                  .navigationTree
                  .fold('Stack', (initial, value) => '$initial -> $value')),
              ElevatedButton(
                child: Text('Go to Page 3'),
                onPressed: () =>
                    AppNavigator().push(Page3(), name: Page3.route),
              ),
              ElevatedButton(
                child: Text('Pop'),
                onPressed: () {
                  AppNavigator().pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  static const String route = 'page3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Page_3'),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                AppNavigator().currentPath ?? 'no path',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w200),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(AppNavigator()
                  .navigationTree
                  .fold('Stack', (initial, value) => '$initial -> $value')),
              ElevatedButton(
                child: Text('popUntilNamed Page1'),
                onPressed: () => AppNavigator().popUntilNamed(Page1.route),
              ),
              ElevatedButton(
                child: Text('Pop'),
                onPressed: () {
                  AppNavigator().pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
