import 'package:flutter/material.dart';

class NotifierProvider<Model extends ChangeNotifier> extends StatefulWidget {
  final Widget child;
  final Model Function() create;
  final bool isManagingModel;
  const NotifierProvider({
    super.key,
    required this.create,
    required this.child,
    this.isManagingModel = true,
  });

  @override
  State<NotifierProvider<Model>> createState() =>
      _NotifierProviderState<Model>();

  static Model? watch<Model extends ChangeNotifier>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedNotifierProvider<Model>>()
        ?.model;
  }

  static Model? read<Model extends ChangeNotifier>(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
          _InheritedNotifierProvider<Model>
        >()
        ?.widget;
    return widget is _InheritedNotifierProvider<Model> ? widget.model : null;
  }
}

class _NotifierProviderState<Model extends ChangeNotifier>
    extends State<NotifierProvider<Model>> {
  late final Model _model;
  @override
  void initState() {
    super.initState();
    _model = widget.create();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedNotifierProvider(model: _model, child: widget.child);
  }

  @override
  void dispose() {
    if (widget.isManagingModel) {
      super.dispose();
      _model.dispose();
    }
  }
}

class _InheritedNotifierProvider<Model extends ChangeNotifier>
    extends InheritedNotifier {
  final Model model;
  const _InheritedNotifierProvider({
    super.key,
    required this.child,
    required this.model,
  }) : super(child: child, notifier: model);

  final Widget child;
}

class Provider<Model> extends InheritedWidget {
  final Model model;
  const Provider({super.key, required this.child, required this.model})
    : super(child: child);

  final Widget child;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return model != oldWidget;
  }
}
