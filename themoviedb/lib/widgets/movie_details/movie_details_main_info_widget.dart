import 'package:flutter/material.dart';
import 'package:themoviedb/resources/resources.dart';
import 'package:themoviedb/widgets/elements/radial_percent_widget.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TopPostersWidget(),
        Padding(padding: EdgeInsets.all(8.0), child: _MovieNameWidget()),
        _ScoreWidget(),
        _SummeryWidget(),
        _OverViewWidget(),
      ],
    );
  }
}

class _TopPostersWidget extends StatelessWidget {
  const _TopPostersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(image: AssetImage((AppImages.topHeader))),
        Positioned(
          top: 20,
          left: 20,
          bottom: 20,
          child: Image(image: AssetImage(AppImages.topHeaderSubImg)),
        ),
      ],
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      maxLines: 3,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Шоу Трумана',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          TextSpan(
            text: ' (1998)',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: RadialPersentWidget(
                  precent: 0.72,
                  fillColor: Color.fromARGB(255, 10, 23, 25),
                  lineColor: Color.fromARGB(255, 37, 203, 103),
                  freeColor: Color.fromARGB(255, 25, 54, 31),
                  lineWidth: 5,
                  child: Text('72'),
                ),
              ),
              SizedBox(width: 10),
              Text('Баллы участников'),
            ],
          ),
        ),
        Container(width: 1, color: Colors.grey, height: 15),
        TextButton(
          onPressed: () {},
          child: Row(
            children: [Icon(Icons.play_arrow), Text(' Воспроизвести трейлер')],
          ),
        ),
      ],
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color.fromRGBO(23, 21, 25, 1.0),

      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        child: Text(
          textAlign: TextAlign.center,
          maxLines: 3,
          '16/10/1998 (RU) комедия/драма',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _OverViewWidget extends StatelessWidget {
  const _OverViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Colors.white,
    );
    final jobStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Colors.white,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Краткое содержание',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Представьте себе, что вы вдруг начинаете понимать, что все вокруг вас — декорации, а люди — актеры, притворяющиеся теми, кем они вам кажутся. Весь ваш мир оказывается большим телесериалом, где вы исполняете главную роль, даже не подозревая об этом. Вся ваша жизнь — результат работы автора телешоу, которое вот уже тридцать лет смотрит вся планета, начиная с момента вашего рождения. В такой ситуации оказался Труман, главный герой картины. Будет ли он продолжать жить в безопасном мире, где, как он теперь знает, у него практически нет свободы выбора, или все-таки выйдет из «игры» и станет сам хозяином своей судьбы, в которой его ждет не запланированная сценарием девушка?',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Colors.white,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Питер Уир', style: nameStyle),
                  Text('Директор', style: jobStyle),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Питер Уир', style: nameStyle),
                  Text('Директор', style: jobStyle),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Питер Уир', style: nameStyle),
                  Text('Директор', style: jobStyle),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Питер Уир', style: nameStyle),
                  Text('Директор', style: jobStyle),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
