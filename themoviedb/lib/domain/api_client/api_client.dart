import 'dart:convert';
import 'dart:io';

import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';

enum APiClientExeptionType { Network, Auth, Other }

class APiClientExeption implements Exception {
  final APiClientExeptionType type;

  APiClientExeption({required this.type});
}

class ApiClient {
  final _client = HttpClient();
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = '0a2a46b5593a0978cc8e87ba34037430';

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = await response.jsonDecode();
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw APiClientExeption(type: APiClientExeptionType.Network);
    } on APiClientExeption {
      rethrow;
    } catch (_) {
      throw APiClientExeption(type: APiClientExeptionType.Other);
    }
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic>? bodyParameters,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = _makeUri(path, urlParameters);

      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw APiClientExeption(type: APiClientExeptionType.Network);
    } on APiClientExeption {
      rethrow;
    } catch (_) {
      throw APiClientExeption(type: APiClientExeptionType.Other);
    }
  }

  Future<String> auth({
    required String username,
    required String password,
  }) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
      username: username,
      password: password,
      requestToken: token,
    );
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Future<String> _makeToken() async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    };

    final result = _get('/authentication/token/new', parser, <String, dynamic>{
      'api_key': _apiKey,
    });
    return result;
  }

  //к фильмам api
  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    };

    final result = _get('/movie/popular', parser, <String, dynamic>{
      'api_key': _apiKey,
      'language': locale.toString(),
      'page': page.toString(),
    });
    return result;
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    };
    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };
    final result = _post(
      '/authentication/token/validate_with_login',
      parameters,
      parser,
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  Future<String> _makeSession({required String requestToken}) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    };
    final parameters = <String, dynamic>{'request_token': requestToken};

    final result = _post(
      '/authentication/session/new',
      parameters,
      parser,
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  static String imageUrl(String path) => _imageUrl + path;

  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    };
    final result = _get('/search/movie', parser, <String, dynamic>{
      'api_key': _apiKey,
      'language': locale.toString(),
      'page': page.toString(),
      'query': query,
      'include_adult': true.toString(),
    });
    return result;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) async {
    // ignore: prefer_function_declarations_over_variables
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    };
    final result = _get('/movie/$movieId', parser, <String, dynamic>{
      'append_to_response': 'credits,videos',
      'api_key': _apiKey,
      'language': locale.toString(),
    });
    return result;
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}

void _validateResponse(HttpClientResponse response, dynamic json) {
  if (response.statusCode == 401) {
    final status = json['status_code'];
    final code = json['status_code'] is int ? status : 0;
    if (code == 30) {
      throw APiClientExeption(type: APiClientExeptionType.Auth);
    } else {
      throw APiClientExeption(type: APiClientExeptionType.Other);
    }
  }
}
