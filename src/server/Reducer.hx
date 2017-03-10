import slobby.Server;
using thx.Arrays;

import common.types.Lobby;
import common.ServerMessage;
import common.ClientMessage;
import Action;

class Reducer {
  public static function reduce(state: State, action: Action): State {
    return switch [state, action] {
      case [Starting, Start(server)]: Running(server, []);
      case [Running(wss, lobbies), LobbyAction(action)]: handleLobbyAction(wss, lobbies, action);

      // ignore actions that don't make sense
      case [Starting, _] | [Running(_), Start(_)]: state;
    }
  }

  static function handleLobbyAction(server: Server<ServerMessage, ClientMessage>, lobbies: Array<Lobby>, action: LobbyAction): State {
    return switch action {
      // `Lobby` is very confused by
      case CreateLobby(owner, size): Running(server, lobbies.append(common.types.Lobby.create(owner, size)));
      case _: Running(server, lobbies);
    }
  }
}
