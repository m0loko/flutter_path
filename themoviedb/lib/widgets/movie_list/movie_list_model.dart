import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/main_navigation/main_navigation.dart';

class MovielistWidgetModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movie = <Movie>[];
  late int _currentPage;
  late int _totalPage;
  String? _searchQuery;
  var _isLoadingInProgres = false;
  List<Movie> get movies => List.unmodifiable(_movie);
  late DateFormat _dateFormat;
  String _locale = '';
  Timer? searchDeboubce;

  Future<PopularMovieResponse> _loadMovies(int nextPage, String locale) async {
    final query = _searchQuery;
    if (query == null) {
      return await _apiClient.popularMovie(nextPage, _locale);
    } else {
      return await _apiClient.searchMovie(nextPage, locale, query);
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingInProgres || _currentPage >= _totalPage) {
      return;
    }
    _isLoadingInProgres = true;
    final nextPage = _currentPage + 1;
    try {
      final moviesResponse = await _loadMovies(nextPage, _locale);
      _movie.addAll(moviesResponse.movies);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
      _isLoadingInProgres = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgres = false;
    }
  }

  void onMovieTap(int index, BuildContext context) {
    final id = _movie[index].id;
    Navigator.of(
      context,
    ).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  String stringFromdate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movie.clear();
    await _loadNextPage();
  }

  void showedMovieAtIndex(int index) {
    if (index < _movie.length - 2) {
      return;
    }
    _loadNextPage();
  }

  Future<void> searchMovie(String text) async {
    searchDeboubce?.cancel();
    searchDeboubce = Timer(const Duration(microseconds: 250), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) {
        return;
      }
      _searchQuery = searchQuery;
      await _resetList();
    });
  }
}
