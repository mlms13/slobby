import common.ServerMessage;
import common.ClientMessage;
import common.resistance.Types;
import server.types.Resistance;

enum State {
  Starting;
  Running(server: slobby.Server<ServerMessage, ClientMessage>, game: GameState);
}
