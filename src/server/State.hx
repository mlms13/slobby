import common.ServerMessage;
import common.ClientMessage;
import types.Resistance;

enum State {
  Starting;
  Running(server: slobby.Server<ServerMessage, ClientMessage>, game: GameState);
}
