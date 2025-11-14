import 'dart:convert';
import 'dart:io';
import 'package:api_client/domain/entity/post.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ApiClient {
  final client = HttpClient();

  Future<List<Post>> getPosts() async {
    final json = await get('https://jsonplaceholder.typicode.com/posts');
    final posts = json
        .map((e) => Post.fromJsom(e as Map<String, dynamic>))
        .toList();
    return posts;
  }

  Future<Post> createPost({required String title, required String body}) async {
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
    final post = Post.fromJsom(json);
    return post;
  }

  Future<List<dynamic>> get(String ulr) async {
    final url = Uri.parse(ulr);
    final request = await client.getUrl(url);
    final response = await request.close();
    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();
    final json = jsonDecode(jsonString) as List<dynamic>;
    return json;
  }

  Future<void> fileUpload(File file) async {
    final url = Uri.parse('https://xz');
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, ContentType.binary);
    request.headers.add('filename', basename(file.path));
    request.contentLength = file.lengthSync();
    final fileStream = file.openRead();
    await request.addStream(fileStream);
    final httpResponse = await request.close();
    if (httpResponse.statusCode == 200) {
      print('ok');
    } else {
      return;
    }
  }
}
