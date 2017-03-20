import slobby.Server;
using thx.Arrays;

import common.ServerMessage;
import common.ClientMessage;
import common.types.User;
import common.resistance.Types;
import Action;

class Reducer {
  public static function reduce(state: State, action: Action): State {
    return switch [state, action] {
      // if the server hasn't started, start it
      case [Starting, Start(server)]: Running(server, Lobby([]));

      // if the server is running and in a lobby state, apply lobby actions
      case [Running(server, Lobby(users)), LobbyAction(who, action)]: handleLobbyAction(server, users, who, action);

      // if the server is in a game state, apply game actions
      case [Running(server, Game(phase)), GameAction(who, action)]: handleGameAction(server, phase, who, action);

      // ignore actions that don't make sense
      case [Starting, _] | [Running(_), Start(_)]: state;

      // for other invalid messages, notify the client
      case [Running(server, Lobby(_)), GameAction(who, _)] |
           [Running(server, Game(_)), LobbyAction(who, _)]:
        server.send(who.connection, Invalid);
    }
  }

  static function handleLobbyAction(server: Server<ServerMessage, ClientMessage>, users: Array<User>, who: User, action: LobbyAction): State {
    return switch action {
      // case Create(owner, size): Running(server, lobbies.append(common.types.Lobby.create(owner, size)));
      case Join:
        // TODO: if lobby.length + this user > threshold...
        // start the game
        Running(server, Lobby(users.append(who)));
    }
  }

  static function handleGameAction(server: Server<ServerMessage, ClientMessage>, phase: GamePhase, user: User, action: GameAction): State {
    return switch action {
      case Vote: // TODO, obviously
        Running(server, Game(phase));
    }
  }
}
