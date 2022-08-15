import 'package:app_navigator/app_navigator.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/pages.dart';

void main() {
  final appNavigator = AppNavigator();

  //Initialize the appNavigator pages before each test

  group('Test AppNavigator', () {
    setUp(() {
      appNavigator.pages.value = [
        AppPage(child: const Page1(), name: Page1.path)
      ];
    });

    //Test the current path method
    test('current_path', () {
      //  Setup
      //  Act
      final currentPath = appNavigator.currentPath;
      //  Verify
      expect(currentPath, equals(Page1.path));
      expect(appNavigator.pages.value.length, equals(1));
    });

    //Test the navigation_tree method
    test('navigation_tree', () {
      //  Setup
      //  Act
      final navigationRoutes = appNavigator.navigationRoutes;
      //  Verify
      expect(navigationRoutes.length, equals(1));
      expect(navigationRoutes.first, equals(Page1.path));
    });

    //Test push method
    test('push', () {
      //  Setup
      //  Act
      appNavigator.push(const Page2(), name: Page2.path);
      //  Verify
      expect(appNavigator.currentPath, equals(Page2.path));
      expect(appNavigator.pages.value.length, equals(2));
      expect(appNavigator.navigationRoutes.length, equals(2));
    });

    // Test pushReplacement. Pushing a page must replace the last page on the tree
    test('pushReplacement', () {
      //  Setup
      appNavigator.push(const Page2(), name: Page2.path);
      //  Act
      appNavigator.pushReplacement(const Page3(), name: Page3.path);
      //  Verify
      expect(appNavigator.currentPath, equals(Page3.path));
      expect(appNavigator.navigationRoutes, contains(Page1.path));
      expect(appNavigator.navigationRoutes, contains(Page3.path));
      expect(appNavigator.navigationRoutes, isNot(contains(Page2.path)));
    });

    // Test pushAndReplaceAllStack. Pushing a page must replace all tree and have only 1 element at end
    test('pushAndReplaceAllStack', () {
      //  Setup
      appNavigator.push(const Page2(), name: Page2.path);
      //  Act
      appNavigator.pushAndReplaceAllStack(const Page3(), name: Page3.path);
      //  Verify
      expect(appNavigator.currentPath, equals(Page3.path));
      expect(appNavigator.pages.value.length, equals(1));
      expect(appNavigator.navigationRoutes, isNot(contains(Page1.path)));
      expect(appNavigator.navigationRoutes, isNot(contains(Page2.path)));
    });

    //Test pop. Remove the last element on the stack. This group will test all alternatives
    group('pop group', () {
      test(
        'pop',
        () {
          //  Setup
          appNavigator.push(const Page2(), name: Page2.path);
          //  Act
          appNavigator.pop();
          //  Verify
          expect(appNavigator.currentPath, equals(Page1.path));
          expect(appNavigator.pages.value.length, equals(1));
          expect(appNavigator.navigationRoutes.length, equals(1));
        },
      );

      //Making pop with only 1 element will no make any action.
      test(
        'pop with 1 element on the stack',
        () {
          //  Setup
          //  Act
          appNavigator.pop();
          //  Verify
          expect(appNavigator.currentPath, equals(Page1.path));
          expect(appNavigator.pages.value.length, equals(1));
          expect(appNavigator.navigationRoutes.length, equals(1));
        },
      );
    });

    //Test pop. Remove all the last element on the stack until the target. This group will test all alternatives
    group('popUntilNamed group', () {
      //Test popUntilNamed
      test(
        'popUntilNamed',
        () {
          //  Setup
          appNavigator.push(const Page2(), name: Page2.path);
          appNavigator.push(const Page3(), name: Page3.path);
          //  Act
          appNavigator.popUntilNamed(Page1.path);
          //  Verify
          expect(appNavigator.currentPath, equals(Page1.path));
          expect(appNavigator.pages.value.length, equals(1));
          expect(appNavigator.navigationRoutes, isNot(contains(Page2.path)));
          expect(appNavigator.navigationRoutes, isNot(contains(Page3.path)));
        },
      );

      //Test popUntilNamed
      test(
        'popUntilNamed with no existing target on the navigation stack',
        () {
          //  Setup
          appNavigator.push(const Page2(), name: Page2.path);
          appNavigator.push(const Page3(), name: Page3.path);
          //  Act
          appNavigator.popUntilNamed('home');
          //  Verify
          expect(appNavigator.currentPath, equals(Page3.path));
          expect(appNavigator.pages.value.length, equals(3));
          expect(appNavigator.navigationRoutes, contains(Page1.path));
          expect(appNavigator.navigationRoutes, contains(Page2.path));
        },
      );
    });

    //Test replacement. This method must replace a target on the navigation stack (doesn't matter the position) with other element
    group('replacement group', () {
      //Test replacement
      test(
        'replacement',
        () {
          //  Setup
          appNavigator.push(const Page2(), name: Page2.path);
          //  Act
          appNavigator.replacement(const Page3(),
              name: Page3.path, target: Page1.path);
          //  Verify
          expect(appNavigator.currentPath, equals(Page2.path));
          expect(appNavigator.pages.value.length, equals(2));
          expect(appNavigator.navigationRoutes, isNot(contains(Page1.path)));
          expect(appNavigator.navigationRoutes, contains(Page3.path));
        },
      );

      //Test replacement. With a wrong target the method doesn't make actions.
      test(
        'replacement with wrong target',
        () {
          //  Setup
          appNavigator.push(const Page2(), name: Page2.path);
          //  Act
          appNavigator.replacement(const Page3(),
              name: Page3.path, target: 'home');
          //  Verify
          expect(appNavigator.currentPath, equals(Page2.path));
          expect(appNavigator.pages.value.length, equals(2));
          expect(appNavigator.navigationRoutes, contains(Page1.path));
          expect(appNavigator.navigationRoutes, isNot(contains(Page3.path)));
        },
      );
    });
  });
}
