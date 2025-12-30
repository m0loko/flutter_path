import 'package:guys_flutter/core/resources/data_state.dart';
import 'package:guys_flutter/core/usecases/usecase.dart';
import 'package:guys_flutter/features/daily_news/domain/entities/article.dart';
import 'package:guys_flutter/features/daily_news/domain/repository/article_repository.dart';

class GetArticle implements Usecase<DataState<List<ArticleEntity>>, void> {
  final ArticleRepository _articleRepository;

  GetArticle({required ArticleRepository articleRepository})
      : _articleRepository = articleRepository;
  @override
  Future<DataState<List<ArticleEntity>>> call({void params}) {
    return _articleRepository.getNewsArticles();
  }
}
