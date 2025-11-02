import 'package:flutter/material.dart';
import 'package:themoviedb/resources/resources.dart';

class Movie {
  final int id;
  final String imageName;
  final String title;
  final String time;
  final String description;

  Movie({
    required this.id,
    required this.imageName,
    required this.title,
    required this.time,
    required this.description,
  });
}

class Movielist extends StatefulWidget {
  Movielist({super.key});

  @override
  State<Movielist> createState() => _MovielistState();
}

class _MovielistState extends State<Movielist> {
  final _movies = [
    Movie(
      id: 1,
      imageName: AppImages.truman,
      title: 'Шоу Трумана',
      time: 'Июнь 1, 1998',
      description:
          'Представьте себе, что вы вдруг начинаете понимать, что все вокруг вас — декорации, а люди — актеры, притворяющиеся теми, кем они вам кажутся. Весь ваш мир оказывается большим телесериалом, где вы исполняете главную роль, даже не подозревая об этом. Вся ваша жизнь — результат работы автора телешоу, которое вот уже тридцать лет смотрит вся планета, начиная с момента вашего рождения.В такой ситуации оказался Труман, главный герой картины. Будет ли он продолжать жить в безопасном мире, где, как он теперь знает, у него практически нет свободы выбора, или все-таки выйдет из «игры» и станет сам хозяином своей судьбы, в которой его ждет не запланированная сценарием девушка?',
    ),
    Movie(
      id: 2,
      imageName: AppImages.truman,
      title: 'Начало',
      time: 'Июль 16, 2010',
      description:
          'Талантливый вор Доминик Кобб — лучший из лучших в опасном искусстве извлечения: он крадет ценные секреты из глубин подсознания во время сна, когда человеческий разум наиболее уязвим. Коббу предлагают шанс совершить идеальное преступление, но для этого ему нужно выполнить невозможное — не украсть идею, а внедрить ее. Если он преуспеет, это станет совершенным преступлением. Однако никакое планирование или мастерство не могут подготовить команду к встрече с опасным противником, который, кажется, предугадывает каждый их ход. Единственный, кто может превзойти Кобба в искусстве подсознательного манипулирования.',
    ),

    Movie(
      id: 3,
      imageName: AppImages.truman,
      title: 'Интерстеллар',
      time: 'Октябрь 26, 2014',
      description:
          'Когда засуха приводит человечество к продовольственному кризису, коллектив исследователей и ученых отправляется сквозь червоточину (которая предположительно соединяет области пространства-времени через большое расстояние) в путешествие, чтобы превзойти прежние ограничения для космических путешествий человека и переселить человечество на другую планету. Фильм исследует темы любви, жертвенности, человеческого выживания и парадоксов времени, когда главный герой сталкивается с невозможным выбором между спасением человечества и возвращением к своей семье.',
    ),

    Movie(
      id: 4,
      imageName: AppImages.truman,
      title: 'Криминальное чтиво',
      time: 'Сентябрь 10, 1994',
      description:
          'Неллифм, состоящий из нескольких историй, переплетающихся в причудливом танце насилия, юмора и философских размышлений. Двое бандитов Винсент Вега и Джулс Винфилд выполняют поручение своего босса Марселласа Уоллеса, философствуя о гамбургерах, массаже стоп и моральных дилеммах. Параллельно мы знакомимся с боксером Бутчем Кулиджем, который должен проиграть бой, но решает сбежать с деньгами, и с милой парой ограбителей ресторана. Каждая история раскрывает персонажей с неожиданной стороны, заставляя зрителя задуматься о случайности и предопределенности событий.',
    ),

    Movie(
      id: 5,
      imageName: AppImages.truman,
      title: 'Темный рыцарь',
      time: 'Июль 18, 2008',
      description:
          'Бэтмен поднимает ставки в войне с преступностью. С помощью лейтенанта Джима Гордона и прокурора Харви Дента он намерен очистить улицы Готэма от преступности, раз и навсегда. Сотрудничество оказывается эффективным, но вскоре они оказываются мишенью Джокера — криминального гения, который сеет хаос в Готэме. Фильм исследует тонкую грань между героем и злодеем, порядком и хаосом, справедливостью и местью. Джокер ставит перед Бэтменом моральные дилеммы, которые бросают вызов самой сути его миссии по спасению города.',
    ),

    Movie(
      id: 6,
      imageName: AppImages.truman,
      title: 'Бойцовский клуб',
      time: 'Сентябрь 10, 1999',
      description:
          'Страдающий от бессонницы сотрудник страховой компании встречает загадочного торговца мылом по имени Тайлер Дарден, харизматичного парня, который проповедует философию освобождения от потребительских ценностей. Вместе они создают подпольный бойцовский клуб как форму мужской терапии, который быстро превращается в нечто гораздо большее и опасное. Фильм исследует темы идентичности, потребительства, мужественности и анархии, заставляя зрителя усомниться в собственных ценностях и восприятии реальности. Крушение планов героя становится метафорой освобождения от социальных ограничений.',
    ),
  ];

  var _filteredMovies = <Movie>[];

  final _searchControlle = TextEditingController();

  void _searchMovies() {
    final query = _searchControlle.text;
    if (query.isNotEmpty) {
      _filteredMovies = _movies.where((Movie movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      _filteredMovies = _movies;
    }
    setState(() {});
  }

  void _onMovieTab(int index) {
    final id = _movies[index].id;
    Navigator.of(
      context,
    ).pushNamed('/main_screen/movie_details', arguments: id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filteredMovies = _movies;
    _searchControlle.addListener(_searchMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(top: 70),
          itemCount: _filteredMovies.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index) {
            final movie = _filteredMovies[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        Image(image: AssetImage(movie.imageName)),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              SizedBox(height: 20),
                              Text(
                                movie.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Text(
                                movie.time,
                                style: TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 20),
                              Text(
                                movie.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: () => _onMovieTab(index),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _searchControlle,
            decoration: InputDecoration(
              labelText: 'Поиск',
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
