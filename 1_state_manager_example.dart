/// Create a generic state manager to mutate a state.

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

void main() {
  StateManager stateManager = StateManager<int>(0);

  print(stateManager.currentState); // 0
  stateManager.emit(1);
  print(stateManager.currentState); // 1
}
