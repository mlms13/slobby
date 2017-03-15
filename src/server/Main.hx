import thx.stream.Property;
import thx.stream.Store;

import slobby.Server;
import common.ClientMessage;
import common.ServerMessage;

class Main {
  public static function main() {
    var state: State = Starting;
    var prop = new Property(state);
    var store = new Store(prop, Reducer.reduce, thx.stream.Reducer.Middleware.empty());

    var slob = Server.create(ServerMessageExtensions.schema(), ClientMessageExtensions.schema(), Port(7700));
    store.dispatch(Start(slob));


    slob.incoming //.run(); // TODO: needs a run() call?
      .message(function (incoming: IncomingMessage<common.ClientMessage>) {
        switch incoming {
          case Connected(client):
            trace("A client connected!");
            slob.send(client, UsernamePrompt);
          case Invalid(client, orig, parseError):
            trace(parseError);
            slob.send(client, Error(Unrecognized(parseError)));
          case Message(_, CreateLobby(user, size)):
            store.dispatch(LobbyAction(CreateLobby(user, size)));
          case Message(_, JoinLobby(user, lobbyId)):
            store.dispatch(LobbyAction(JoinLobby(user, lobbyId)));
        }
      });
  }
}
