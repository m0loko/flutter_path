import 'package:flutter/material.dart';
import 'package:flutter_fest/application/ui/screens/main_tabs/main_tabs_view_model.dart';
import 'package:flutter_fest/resources/resources.dart';
import 'package:provider/provider.dart';

class MainTabsScreen extends StatelessWidget {
  const MainTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Container(color: Colors.white)]),
      bottomNavigationBar: _NavBarWidget(),
    );
  }
}

class _NavBarWidget extends StatelessWidget {
  const _NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select(
      (MainTabsViewModel vm) => vm.currentTabIndex,
    );
    final model = context.read<MainTabsViewModel>();
    final theme = Theme.of(context).bottomNavigationBarTheme;
    final buttons =
        [
          _BottomNavigationBarItemFactory(
            iconName: AppImages.tabbarCalendar,
            tooltip: 'Расписание',
          ),
          _BottomNavigationBarItemFactory(
            iconName: AppImages.tabbarBookmark,
            tooltip: 'Избравнное',
          ),
          _BottomNavigationBarItemFactory(
            iconName: AppImages.tabbarPoint,
            tooltip: 'Как доюравться',
          ),
        ].asMap().map((index, value) {
          return MapEntry(index, value, currentIndex);
        });
    List.generate(3, (index) => null);
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.red,
      items: buttons,
      onTap: model.setCurrentTabIndex,
    );
  }
}

BottomNavigationBarItem _makeButton(
  String iconName,
  String tooltip,
  int index,
  int currentIndex,
  BottomNavigationBarThemeData theme,
) {
  final color = index == currentIndex
      ? theme.selectedItemColor
      : theme.unselectedItemColor;
  return BottomNavigationBarItem(
    icon: Image.asset(iconName, color: color),
    label: '',
    tooltip: tooltip,
  );
}

class _BottomNavigationBarItemFactory {
  final String iconName;
  final String tooltip;

  _BottomNavigationBarItemFactory({
    required this.iconName,
    required this.tooltip,
  });
  BottomNavigationBarItem _makeButton(
    int index,
    int currentIndex,
    BottomNavigationBarThemeData theme,
  ) {
    final color = index == currentIndex
        ? theme.selectedItemColor
        : theme.unselectedItemColor;
    return BottomNavigationBarItem(
      icon: Image.asset(iconName, color: color),
      label: '',
      tooltip: tooltip,
    );
  }
}
