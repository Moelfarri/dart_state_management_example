import 'dart:async';

/// The next thing to do from here is to add events
/// to our state manager. This is where the BloC Pattern
/// truly shines.

abstract class Streamable<State extends Object?> {
  Stream<State> get stream;
}

abstract interface class Emittable<State extends Object?> {
  void emit(State newState);
}

abstract class StateManager<State>
    implements Emittable<State>, Streamable<State> {
  //fields
  State? _previousState;
  late State _currentState;
  late final _stateController = StreamController<State>.broadcast();

  @override
  Stream<State> get stream => _stateController.stream;

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
    _stateController.add(_currentState);
  }
}

/// For the simple example of a counter we have two events
/// increment and decrement. We can create event classes for these things
abstract class Bloc<Event, State> extends StateManager<State> {
  Bloc(State initialState) : super(initialState);

  void add(Event event);
}

//-- NEW --
abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}
//-- NEW --

//-- NEW --
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc(int initialState) : super(initialState);

  @override
  void add(CounterEvent event) {
    switch (event.runtimeType) {
      case IncrementEvent:
        _onIncrement();
        break;
      case DecrementEvent:
        _onDecrement();
        break;
    }
  }

  void _onIncrement() {
    emit(currentState + 1);
  }

  void _onDecrement() {
    emit(currentState - 1);
  }
}
//-- NEW --

Future<void> main() async {
  CounterBloc counterBloc = CounterBloc(0);

  counterBloc.stream.listen((state) {
    print(state);
  });

  //every half a second emit a new state
  await Timer.periodic(
    Duration(milliseconds: 500),
    (timer) {
      counterBloc.add(IncrementEvent());

      if (counterBloc.currentState == 5) {
        timer.cancel();
      }
    },
  );
}


/// The BLoC pattern is designed to seperate the business logic as 
/// much as possible. And what is interesting is that 
/// from our small example of a State manager we have derived a
/// generic BLoC class that takes in a generic Event and State. 
/// Then based on the incoming events we can mutate state accordingly and
/// in a well defined manner. Furthermore by just exposing the add method
/// we can add events and state will be mutated accordingly. 
/// This is the power of the BLoC pattern.

/// How ever i show a simple example of the BLoC pattern here, and 
/// that is exactly what it is a simple example. In a real world scenario
/// you would have to handle a lot more complexity, such as:
/// - Error states, what happens if for example a stream closes unexpectedly?
/// - Logging, how do you log events and states as they happen?
/// - Testing, how do you test your BLoC?
/// - How do you connect this to a UI? You probably need to use a Consumer widget such as 
/// the StreamBuilder widget as a listener of the state BLoC stream. You also 
/// need a way to pass down your BLoC to the widget tree, this is done
/// through defining a generic InheritedWidget that holds the BLoC and makes
/// it accessible to the widget tree. 
/// 
/// and much much more for which are handled out of the box by packages
/// such as the flutter_bloc package.