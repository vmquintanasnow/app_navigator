part of 'app_navigator.dart';

///A widget that manages all the navigation changes.
///Uses a imperative declaration follow the Navigator 2.0 guidelines.
class NavigationLayer extends StatefulWidget {
  final Widget initPage;
  final String initPath;

  const NavigationLayer(
      {Key? key, required this.initPage, required this.initPath})
      : super(key: key);

  @override
  State<NavigationLayer> createState() => _NavigationLayerState();
}

class _NavigationLayerState extends State<NavigationLayer> {
  @override
  void initState() {
    AppNavigator().pages.value = [
      AppPage(child: widget.initPage, name: widget.initPath)
    ];
    super.initState();
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
              AppNavigator().pop(result);
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
