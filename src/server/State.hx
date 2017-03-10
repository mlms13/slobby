import common.types.Lobby;
import common.ServerMessage;
import common.ClientMessage;

enum State {
  Starting;
  Running(server: slobby.Server<ServerMessage, ClientMessage>, lobbies: Array<Lobby>);
}
