
# App Navigator

A declarative implementation of Flutter's Navigator for easy and clean code.

## Features

- Easy to integrate & easy to use
- Uses Flutter's Navigator v2.0

## Getting started

Add this package as a dependency

```shell
flutter pub add app_navigator
```

Import this package in your file
```dart
import 'package:app_navigator/app_navigator.dart';
```

## Usage

### Setup

1. Create a `List<NavigationPath>`
```dart
import 'package:flutter/material.dart';
import 'package:app_navigator/app_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
```


## Navigation
### Push
To navigate between routes, use the `AppNavigator.push` method:

```dart
onTap() => AppNavigator().push(Page(), name: 'page');
```
### Pop
To navigate backward, use the `AppNavigator.pop` method:

```dart
onTap() => AppNavigator().pop();
```

### PopUntilNamed
To navigate backward to a target page, use `AppNavigator.popUntilNamed`

```dart
onTap() => AppNavigator().popUntilNamed();
```

### Context-less navigation
The class `AppNavigator` by using the singleton pattern allows navigation within the app without care about the context.

