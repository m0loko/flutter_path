import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guys_flutter/config/theme/app_themes.dart';
import 'package:guys_flutter/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:guys_flutter/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:guys_flutter/features/daily_news/presentation/pages/home/daily_news.dart';
import 'package:guys_flutter/injection_container.dart';

void main() async {
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteArticleBloc>(
      create: (context) => sl()..add(const GetArticles()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: const DailyNews(),
      ),
    );
  }
}
