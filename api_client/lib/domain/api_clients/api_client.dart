import 'dart:convert';
import 'dart:io';

import 'package:api_client/domain/entity/post.dart';

class ApiClient {
  final client = HttpClient();
  Future<List<Post>> getPosts() async {
    /*   final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final request = await client.getUrl(url);
    final response = await request.close(); //отправляем в сеть

    final jsonStrings = await response
        .transform(utf8.decoder)
        .toList(); //ждём ну и потом преобразуем
    final jsonString = jsonStrings.join(); */
    final json =
        await get('https://jsonplaceholder.typicode.com/posts')
            as List<dynamic>;
    final posts = json
        .map((e) => Post.fromjson(e as Map<String, dynamic>))
        .toList();
    return posts;
  }

  Future<dynamic> get(String ulr) async {
    final url = Uri.parse(ulr);
    final request = await client.getUrl(url);
    final response = await request.close(); //отправляем в сеть

    final jsonStrings = await response
        .transform(utf8.decoder)
        .toList(); //ждём ну и потом преобразуем
    final jsonString = jsonStrings.join();
    final dynamic json = jsonDecode(jsonString);

    return json;
  }

  Future<Post>? createPost({
    required String title,
    required String body,
  }) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final parameters = <String, dynamic>{
      'title': title,
      'body': body,
      'userId': 109,
    };
    final request = await client.postUrl(url);
    request.headers.set('Content-type', 'application/json; charset=UTF-8');
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return Post.fromjson(json);
  }
}
