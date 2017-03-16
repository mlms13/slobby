class Reducer {
  public static function reduce(state: State, action: Action): State {
    trace(action);
    return NotConnected;
  }
}
