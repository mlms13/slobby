import common.ServerMessage;
import common.ClientMessage;

enum State {
  NotConnected;
  FailedConnection(err: String);
  Connected(socket: slobby.Client<ServerMessage, ClientMessage>, appState: AppState);
}

enum AppState {
  Initial;
  LoginForm;
  Lobby;
}
