import 'package:guys_flutter/core/resources/data_state.dart';
import 'package:guys_flutter/features/daily_news/domain/entities/article.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();
}
