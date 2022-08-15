part of 'app_navigator.dart';

///A widget that manages all the navigation changes.
///Uses a imperative declaration follow the Navigator 2.0 guidelines.
class NavigationLayer extends StatelessWidget {
  final Widget initPage;
  final String initPath;

  NavigationLayer({Key? key, required this.initPage, required this.initPath}) : super(key: key) {
    AppNavigator().pages.value = [AppPage(child: initPage, name: initPath)];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Page>>(
      valueListenable: AppNavigator().pages,
      builder: (BuildContext context, pages, _) {
        return Navigator(
          key: const Key('navigator'),
          transitionDelegate: const DefaultTransitionDelegate(),
          pages: pages,
          onPopPage: (route, result) {
            if (route.didPop(result)) {
              AppNavigator().pop();
              return true;
            } else {
              return false;
            }
          },
        );
      },
    );
  }
}
