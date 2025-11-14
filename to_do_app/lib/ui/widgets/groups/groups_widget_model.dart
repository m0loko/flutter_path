import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/domain/data_provider/box_manager.dart';
import 'package:to_do_app/domain/entity/group.dart';
import 'package:to_do_app/ui/navigation/main_navigation.dart';
import 'package:to_do_app/ui/widgets/tasks/tasks_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;
  GroupsWidgetModel() {
    _setup();
  }
  var _groups = <Group>[];
  List<Group> get groups => _groups.toList();

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int indexInList) async {
    final group = (await _box).getAt(indexInList);
    if (group != null) {
      final configuration = TaskWidgetConfiguration(
        group.key as int,
        group.name,
      );
      unawaited(
        Navigator.of(
          context,
        ).pushNamed(MainNavigationRouteNames.tasks, arguments: configuration),
      );
    }
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  Future<void> deleteGroup(int indexInList) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(indexInList) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(indexInList);
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class GroupWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupWidgetModelProvider({
    super.key,
    required this.child,
    required this.model,
  }) : super(child: child, notifier: model);

  final Widget child;

  static GroupWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupWidgetModelProvider>()
        ?.widget;
    return widget is GroupWidgetModelProvider ? widget : null;
  }

  static GroupWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupWidgetModelProvider>();
  }
}
