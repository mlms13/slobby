import common.ServerMessage;

class Reducer {
  public static function reduce(state: State, action: Action): State {
    trace(action);
    return switch [state, action] {
      // connect to server
      case [_, Ui(Connect(socket))]: Connected(socket, Initial);

      // failed connecting to server
      case [_, Ui(Failed(err))]: FailedConnection(err);

      // connected, message from server
      case [Connected(socket, _), Server(act)]: handleServerAction(state, socket, act);

      // unreachable, and states that don't make sense
      case [NotConnected, Server(msg)] |
           [FailedConnection(_), Server(msg)]:
           trace("not connected or failed but got message", msg);
           state;
    };
  }

  static function handleServerAction(state, socket, action: ServerMessage): State {
    return switch action {
      case UsernamePrompt:
        Connected(socket, LoginForm);
      case Error(AuthRequired):
        trace("auth required");
        state;
      case Error(LobbyFull):
        trace("the lobby you are trying to join is full");
        state;
      case Error(Invalid(err)):
        trace("the last message you sent to the server was invalid", err);
        state;
      case Error(FailureToParse(err)):
        trace("Could not parse message from client", err);
        state;
      case Lobby(lobby, UserJoined(user)):
        trace("a user joined the current lobby", user);
        state;
      case Lobby(lobby, UserDisconnected(user)):
        trace("a user left", user);
        state;
      case Game: // TODO
        state; // TODO
    };
  }
}
