import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_timer/ticker.dart';
part 'timer_state.dart';
part 'timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const int _duration = 60;
  TimerBloc({required Ticker ticker})
    : _ticker = ticker,
      super(TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
  }
}
