import common.ServerMessage;
import common.ClientMessage;

enum Action {
  Ui(act: UiAction);
  Server(act: common.ServerMessage);
}

enum UiAction {
  Connect(socket: slobby.Client<ServerMessage, ClientMessage>);
  Failed(err: String);
}
