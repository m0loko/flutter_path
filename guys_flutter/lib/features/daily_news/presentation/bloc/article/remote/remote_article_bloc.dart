import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guys_flutter/core/resources/data_state.dart';
import 'package:guys_flutter/features/daily_news/domain/usecases/get_article.dart';
import 'package:guys_flutter/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:guys_flutter/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class RemoteArticleBloc extends Bloc<RemoteArticleEvent, RemoteArticleState> {
  final GetArticle _getArticleUseCase;
  RemoteArticleBloc(this._getArticleUseCase) : super(RemoteArticlesLoading()) {
    on<GetArticles>((event, emit) async {
      final dataState = await _getArticleUseCase();
      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(RemoteArticlesDone(dataState.data!));
      }
      if (dataState is DataFailed) {
        emit(RemoteArticlesError(dataState.error));
      }
    });
  }
}
