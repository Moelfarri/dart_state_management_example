/// Let us enforce some sort of interface on the StateManager by
/// creating an abstract class Emittable that has a method emit
/// that the StateManager class must implement.

//-- NEW --
abstract interface class Emittable<State extends Object?> {
  void emit(State newState);
}
//-- NEW --

abstract class StateManager<State> implements Emittable<State> {
  //fields
  State? _previousState;
  late State _currentState;

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
  }
}

class CounterStateManager extends StateManager<int> {
  CounterStateManager(int initialState) : super(initialState);

  void increment() {
    emit(currentState + 1);
  }

  void decrement() {
    emit(currentState - 1);
  }
}

void main() {
  CounterStateManager counterStateManager = CounterStateManager(0);

  print(counterStateManager.currentState); // 0
  counterStateManager.increment();
  print(counterStateManager.currentState); // 1
  counterStateManager.decrement();
  print(counterStateManager.currentState); // 0
}
