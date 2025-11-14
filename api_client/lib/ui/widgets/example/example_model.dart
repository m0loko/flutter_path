import 'package:api_client/domain/api_clients/api_client.dart';
import 'package:api_client/domain/entity/post.dart';
import 'package:flutter/material.dart';

class ExampleWidgetModel extends ChangeNotifier {
  final apiClient = ApiClient();
  var _posts = <Post>[];
  List<Post> get posts => _posts;
  void createPost() async {
    final post = await apiClient.createPost(title: 'vfvf', body: 'hello');
  }

  void reloadPosts() async {
    final posts = await apiClient.getPosts();
    _posts += posts;
    notifyListeners();
  }
}

class ExampleModelProvider extends InheritedNotifier {
  final ExampleWidgetModel model;
  const ExampleModelProvider({
    super.key,
    required this.model,
    required this.child,
  }) : super(child: child, notifier: model);

  final Widget child;

  static ExampleModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ExampleModelProvider>();
  }

  static ExampleModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ExampleModelProvider>()
        ?.widget;
    return widget is ExampleModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(ExampleModelProvider oldWidget) {
    return true;
  }

 
}
