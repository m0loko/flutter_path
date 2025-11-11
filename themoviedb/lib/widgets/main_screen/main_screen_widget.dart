import 'package:flutter/material.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/library/Widgets/Inherited/provider.dart';
import 'package:themoviedb/widgets/main_screen/main_screen_model.dart';
import 'package:themoviedb/widgets/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  void onSelectTab(int index) {
    if (index == _selectedTab) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MainScreenModel>(context);
    print(model);
    return Scaffold(
      appBar: AppBar(
        title: Text('TMDB', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () => SessionDataProvider().setSessionId(null),
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [Text('Новости'), Movielist(), Text('Сериалы')],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Новости'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Фильмы'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Сериалы'),
        ],
        onTap: onSelectTab,
      ),
    );
  }
}
