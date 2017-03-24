class Reducer {
  public static function reduce(state: State, action: Action): State {
    trace(action);
    return switch [state, action] {
      // connect to server
      case [NotConnected, Ui(Connect(socket))] |
           [FailedConnection(_), Ui(Connect(socket))]: Connected(socket);

      // failed connecting to server
      case [NotConnected, Ui(Failed(err))] |
           [FailedConnection(_), Ui(Failed(err))]: FailedConnection(err);

      // connected, message from server
      case [Connected(socket), Server(act)]: handleServerAction(state, socket, act);

      // unreachable, and states that don't make sense
      case [NotConnected, Server(_)] |
           [FailedConnection(_), Server(_)] |
           [Connected(_), Ui(Connect(_))] |
           [Connected(_), Ui(Failed(_))]: state;
    };
  }

  static function handleServerAction(state, socket, action) {
    return state;
  }
}
