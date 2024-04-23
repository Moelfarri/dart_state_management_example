/// Create a generic state manager and add class that extends it
/// to mutate a specific state, as well as
/// add business logic to mutate the state

class StateManager<State> {
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

//-- NEW --
class CounterStateManager extends StateManager<int> {
  CounterStateManager(int initialState) : super(initialState);

  void increment() {
    emit(currentState + 1);
  }

  void decrement() {
    emit(currentState - 1);
  }
}
//-- NEW --

void main() {
  CounterStateManager counterStateManager = CounterStateManager(0);

  print(counterStateManager.currentState); // 0
  counterStateManager.increment();
  print(counterStateManager.currentState); // 1
  counterStateManager.decrement();
  print(counterStateManager.currentState); // 0
}
