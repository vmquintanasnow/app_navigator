library app_navigator;

import 'dart:async';

import 'package:flutter/material.dart';

part 'navigation_layer.dart';

/// A widget that manages a set of child widgets with a stack discipline.
class AppNavigator {
  static final AppNavigator _singleton = AppNavigator._internal();

  AppNavigator._internal();

  factory AppNavigator() => _singleton;

  /// The stack of pages of the app_navigator
  ValueNotifier<List<GeneralPage>> pages = ValueNotifier(<GeneralPage>[]);

  /// Push the given route onto the app_navigator.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _openPage() => AppNavigator().push(const Home(), name: 'home');
  /// dynamic _openPage() async => await AppNavigator().push(const Home(), name: 'home');
  /// ```
  Future<dynamic> push(
    Widget child, {
    bool fullScreenDialog = false,
    required String name,
  }) {
    final page = AppPage(
      child: child,
      fullScreenDialog: fullScreenDialog,
      name: name,
    );
    pages.value = List.from(pages.value)..add(page);

    return page.popped;
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
  Future<dynamic> pushAndReplaceAllStack(
    Widget child, {
    bool fullScreenDialog = false,
    required String name,
  }) {
    final page = AppPage(
      child: child,
      fullScreenDialog: fullScreenDialog,
      name: name,
    );
    pages.value = [page];

    return page.popped;
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
  Future<dynamic> pushReplacement(
    Widget child, {
    required String name,
  }) {
    final page = AppPage(
      child: child,
      name: name,
      fullScreenDialog: false,
    );
    pages.value.last.pop();
    pages.value = List.from(pages.value)..last = page;

    return page.popped;
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
  void pop([dynamic value]) {
    if (pages.value.length > 1) {
      pages.value.last.pop(value);
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
  void popUntilNamed(String path, [dynamic value]) {
    if (pages.value.any((element) => element.name == path)) {
      final List<GeneralPage> pagesCopy = List.from(pages.value);
      while (pagesCopy.last.name != path) {
        pagesCopy.last.pop(value);
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
  Future<dynamic> replacement(
    Widget child, {
    required String name,
    required String target,
  }) {
    final targetIndex = pages.value.indexWhere((element) => element.name == target);
    if (targetIndex >= 0) {
      final List<GeneralPage> pagesCopy = List.from(pages.value);
      final page = AppPage(
        child: child,
        name: name,
        fullScreenDialog: false,
      );
      pagesCopy[targetIndex].pop();
      pagesCopy[targetIndex] = page;

      pages.value = pagesCopy;

      return page.popped;
    } else {
      return Future.value(null);
    }
  }

  /// Displays a Material dialog above the current contents of the app, with
  /// Material entrance and exit animations, modal barrier color, and modal
  /// barrier behavior (dialog is dismissible with a tap on the barrier).
  ///
  /// This function takes a `builder` which typically builds a [Dialog] widget.
  /// Content below the dialog is dimmed with a [ModalBarrier]. The widget
  /// returned by the `builder` does not share a context with the location that
  /// `showDialog` is originally called from. Use a [StatefulBuilder] or a
  /// custom [StatefulWidget] if the dialog needs to update dynamically.
  ///
  /// The `barrierDismissible` argument is used to indicate whether tapping on the
  /// barrier will dismiss the dialog. It is `true` by default and can not be `null`.
  ///
  /// The `barrierColor` argument is used to specify the color of the modal
  /// barrier that darkens everything below the dialog. If `null` the default color
  /// `Colors.black54` is used.
  ///
  /// The `useSafeArea` argument is used to indicate if the dialog should only
  /// display in 'safe' areas of the screen not used by the operating system
  /// (see [SafeArea] for more details). It is `true` by default, which means
  /// the dialog will not overlap operating system areas. If it is set to `false`
  /// the dialog will only be constrained by the screen size. It can not be `null`.
  ///
  /// See also:
  ///
  ///  * [AlertDialog], for dialogs that have a row of buttons below a body.
  ///  * [SimpleDialog], which handles the scrolling of the contents and does
  ///    not show buttons below its body.
  ///  * [Dialog], on which [SimpleDialog] and [AlertDialog] are based.
  ///  * [showCupertinoDialog], which displays an iOS-style dialog.
  ///  * [showGeneralDialog], which allows for customization of the dialog popup.
  ///  * [DisplayFeatureSubScreen], which documents the specifics of how
  ///    [DisplayFeature]s can split the screen into sub-screens.
  ///  * <https://material.io/design/components/dialogs.html>
  Future<dynamic> showDialog({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) {
    final page = DialogPage(
      builder: builder,
      name: 'dialog',
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
    );
    pages.value = List.from(pages.value)..add(page);

    return page.popped;
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

///This class contains all actions required to return values using [pop] feature.
///All Pages on the AppNavigator will extend from this class.
///Extends from [Page] but doesn't implement the [createRoute], the implementation
///of this method is responsibility of the classes that inherit from [GeneralPage].
abstract class GeneralPage extends Page<dynamic> {
  GeneralPage({LocalKey? key, String? name}) : super(key: key, name: name);

  Future<dynamic> get popped => _popCompleter.future;
  final Completer<dynamic> _popCompleter = Completer<dynamic>();

  void pop([dynamic response]) {
    _popCompleter.complete(response);
  }
}

/// A modal route that replaces the entire screen with a platform-adaptive
/// transition.
/// This class is an specific implementation of [GeneralPage] and [Page]. Is used to handle
/// transitions between pages.
/// /// The `fullscreenDialog` property specifies whether the incoming route is a
// /// fullscreen modal dialog. On iOS, those routes animate from the bottom to the
// /// top rather than horizontally.
class AppPage extends GeneralPage {
  AppPage({
    required this.child,
    required String name,
    this.fullScreenDialog,
  }) : super(key: UniqueKey(), name: name);

  final Widget child;

  final bool? fullScreenDialog;

  /// Creates the [Route] that corresponds to this page.
  @override
  Route<dynamic> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      fullscreenDialog: fullScreenDialog ?? false,
      builder: (context) => child,
    );
  }
}

/// This class display a Material Dialog
/// This class is an specific implementation of [GeneralPage] and [Page]. Is used to handle
/// transitions between pages.
/// This function takes a `builder` which typically builds a [Dialog] widget.
///  Content below the dialog is dimmed with a [ModalBarrier]. The widget
///  returned by the `builder` does not share a context with the location that
///  `showDialog` is originally called from. Use a [StatefulBuilder] or a
///  custom [StatefulWidget] if the dialog needs to update dynamically.
///
///  The `barrierDismissible` argument is used to indicate whether tapping on the
///  barrier will dismiss the dialog. It is `true` by default and can not be `null`.
///
///  The `barrierColor` argument is used to specify the color of the modal
///  barrier that darkens everything below the dialog. If `null` the default color
///  `Colors.black54` is used.
///
///   The `useSafeArea` argument is used to indicate if the dialog should only
///   display in 'safe' areas of the screen not used by the operating system
///   (see [SafeArea] for more details). It is `true` by default, which means
///   the dialog will not overlap operating system areas. If it is set to `false`
///   the dialog will only be constrained by the screen size. It can not be `null`.

class DialogPage extends GeneralPage {
  final WidgetBuilder builder;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool useSafeArea;
  final Offset? anchorPoint;

  DialogPage({
    required String name,
    required this.builder,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.useSafeArea = true,
    this.anchorPoint,
  }) : super(name: name);

  /// Creates the [Route] that corresponds to this page.
  @override
  Route createRoute(BuildContext context) {
    return DialogRoute(
      context: context,
      builder: builder,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: this,
      anchorPoint: anchorPoint,
    );
  }
}
