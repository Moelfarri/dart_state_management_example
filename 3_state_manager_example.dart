/// Same thing as example two but now we make the StateManager abstract
/// so we only can extend or implement the base class to create a new state manager
/// instead of using it directly.

//-- NEW --
abstract class StateManager<State> {
//-- NEW --

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
