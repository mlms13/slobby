import npm.ws.Server;
using thx.Arrays;

import common.types.Lobby;
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

  static function handleLobbyAction(wss: Server, lobbies: Array<Lobby>, action: LobbyAction): State {
    return switch action {
      case CreateLobby(owner, size): Running(wss, lobbies.append(Lobby.create(owner, size)));
      case _: Running(wss, lobbies);
    }
  }
}
