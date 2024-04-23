import 'dart:async';

/// our state manager now works perfectly fine, and what
/// what we've really done now allows us the flexibility
/// to build more state managers that can be used in different
/// ways. Thanks to the Dart out of the box support for streams
/// we can easily add a stream to our state manager to listen
/// to state changes and pipe them out to every listener
/// that is interested in the state changes.
/// We add a  stream controller to our state manager, which gives
/// us the ability to control the flow of states into the stream.
///
/// The same way we enforced Emittable interface on the StateManager
/// we can enforce Streamable interface on the StateManager
/// to ensure that every state manager has a state streamer.

//-- NEW --
abstract class Streamable<State extends Object?> {
  Stream<State> get stream;
}
//-- NEW --

abstract interface class Emittable<State extends Object?> {
  void emit(State newState);
}

abstract class StateManager<State>
    implements Emittable<State>, Streamable<State> {
  //fields
  State? _previousState;
  late State _currentState;

  //-- NEW --
  late final _stateController = StreamController<State>.broadcast();

  @override
  Stream<State> get stream => _stateController.stream;
  //-- NEW --

  //constructor
  StateManager(State initialState) {
    _currentState = initialState;
  }

  //getters
  State get currentState => _currentState;
  State? get previousState => _previousState!;

  void emit(State newState) {
    _previousState = _currentState;
    _currentState = newState;

    //-- NEW --
    _stateController.add(_currentState);
    //-- NEW --
  }
}

/// For most cases this would be enough because now we can listen to state changes
/// and react to them accordingly. What we created here is literally a
/// general simplified BLoC pattern or Cubit as it is known in the Flutter community.

//-- NEW --
abstract class Cubit<State> extends StateManager<State> {
  Cubit(State initialState) : super(initialState);
}
//-- NEW --

//-- NEW --
//now if we create a cubit
class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(initialState);

  void increment() {
    emit(currentState + 1);
  }

  void decrement() {
    emit(currentState - 1);
  }
}
//-- NEW --

Future<void> main() async {
  CounterCubit counterCubit = CounterCubit(0);

  counterCubit.stream.listen((state) {
    print(state);
  });

  //every half a second emit a new state
  await Timer.periodic(
    Duration(milliseconds: 500),
    (timer) {
      counterCubit.increment();

      if (counterCubit.currentState == 5) {
        timer.cancel();
      }
    },
  );
}
