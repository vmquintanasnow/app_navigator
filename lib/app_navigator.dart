library app_navigator;

import 'package:flutter/material.dart';

part 'navigation_layer.dart';

/// A widget that manages a set of child widgets with a stack discipline.
class AppNavigator {
  static final AppNavigator _singleton = AppNavigator._internal();

  AppNavigator._internal();

  factory AppNavigator() => _singleton;

  /// The stack of pages of the app_navigator
  ValueNotifier<List<Page>> pages = ValueNotifier(<Page>[]);

  /// Push the given route onto the app_navigator.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _openPage() => AppNavigator().push(const Home(), name: 'home');
  /// ```
  void push(
    Widget child, {
    bool fullScreenDialog = false,
    required String name,
  }) {
    pages.value = List.from(pages.value)
      ..add(AppPage(
        child: child,
        fullScreenDialog: fullScreenDialog,
        name: name,
      ));
  }

  /// Replace all routes of the app_navigator by pushing the given route and
  /// then disposing all the previous routes once the new route has finished
  /// animating in.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _openPage() => AppNavigator().pushAndReplaceAllStack(const Home(), name: 'home');
  /// ```
  void pushAndReplaceAllStack(
    Widget child, {
    bool fullScreenDialog = false,
    required String name,
  }) {
    pages.value = [
      AppPage(
        child: child,
        fullScreenDialog: fullScreenDialog,
        name: name,
      )
    ];
  }

  /// Replace the current route of the app_navigator by pushing the given route and
  /// then disposing the previous route once the new route has finished
  /// animating in.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _openPage() => AppNavigator().pushReplacement(const Home(), name: 'home');
  /// ```
  void pushReplacement(
    Widget child, {
    required String name,
  }) {
    pages.value = List.from(pages.value)
      ..last = AppPage(
        child: child,
        name: name,
        fullScreenDialog: false,
      );
  }

  /// Pop the top-most route off the navigator.
  ///
  /// Typical usage for closing a route is as follows:
  ///
  /// ```dart
  /// void _handleClose() {
  ///   AppNavigator.pop();
  /// }
  /// ```
  void pop() {
    if (pages.value.length > 1) {
      pages.value = List.from(pages.value)..removeLast();
    }
  }

  /// Calls [pop] repeatedly until find the target route.
  ///
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _doLogout() {
  ///   AppNavigator.popUntilNamed('login');
  /// }
  /// ```
  /// {@end-tool}
  void popUntilNamed(String path) {
    if (pages.value.any((element) => element.name == path)) {
      final List<Page> pagesCopy = List.from(pages.value);
      while (pagesCopy.last.name != path) {
        pagesCopy.removeLast();
      }
      pages.value = pagesCopy;
    }
  }

  /// Replace the target route of the app_navigator by pushing the given route and
  /// then disposing the previous route once.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _openPage() => AppNavigator().replacement(const Home(), name: 'home', target: 'login');
  /// ```
  void replacement(
    Widget child, {
    required String name,
    required String target,
  }) {
    final targetIndex = pages.value.indexWhere((element) => element.name == target);
    if (targetIndex >= 0) {
      final List<Page> pagesCopy = List.from(pages.value);
      pagesCopy[targetIndex] = AppPage(
        child: child,
        name: name,
        fullScreenDialog: false,
      );

      pages.value = pagesCopy;
    }
  }

  /// Returns a [String] with the route of the active screen
  ///
  /// Example:
  /// ```dart
  /// final routes = AppNavigator().currentPath; // 'home'
  String? get currentPath {
    return pages.value.last.name;
  }

  /// Returns a new [Iterable] with all elements routes of
  /// the [AppNavigator] stack.

  ///
  /// Example:
  /// ```dart
  /// final routes = AppNavigator().navigationRoutes; // ['home', 'page1']
  Iterable<String> get navigationRoutes {
    return pages.value.map((page) => page.name ?? 'nameLess page');
  }
}

/// A modal route that replaces the entire screen with a platform-adaptive
/// transition.
/// This class is an specific implementation of [Page]. Is used to handle
/// transitions between pages.
/// /// The `fullscreenDialog` property specifies whether the incoming route is a
// /// fullscreen modal dialog. On iOS, those routes animate from the bottom to the
// /// top rather than horizontally.
class AppPage extends Page<dynamic> {
  AppPage({
    required this.child,
    required String name,
    this.fullScreenDialog,
  }) : super(key: UniqueKey(), name: name);

  final Widget child;
  final bool? fullScreenDialog;

  /// Creates the [Route] that corresponds to this page.
  ///
  /// The created [Route] must have its [Route.settings] property set to this [Page].
  @override
  Route<dynamic> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      fullscreenDialog: fullScreenDialog ?? false,
      builder: (context) => child,
    );
  }
}
