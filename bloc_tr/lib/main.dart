import 'package:bloc_tr/color_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ColorBloc _bloc = ColorBloc();
  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    bloc.close();
  }

  final bloc = CounterBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloс with stream')),
      body: Center(
        child: StreamBuilder(
          stream: _bloc.outputStateStream,
          initialData: Colors.red,
          builder: (context, snapshot) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: 100,
              width: 100,
              color: snapshot.data,
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: .end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              _bloc.inputEventSink.add(ColorEvent.event_red);
            },
            backgroundColor: Colors.red,
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _bloc.inputEventSink.add(ColorEvent.event_green);
            },
            backgroundColor: Colors.green,
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () async {
              bloc.add(CounterincrementPressed());
              await Future.delayed(Duration.zero);
            },
          ),
        ],
      ),
    );
  }
}
