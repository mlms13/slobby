import thx.stream.Property;
import thx.stream.Store;

import slobby.Server;
import common.ClientMessage;
import common.ServerMessage;
import types.User;

class Main {
  public static function main() {
    var state: State = Starting;
    var prop = new Property(state);
    var store = new Store(prop, Reducer.reduce, thx.stream.Reducer.Middleware.empty());

    var slob = Server.create(ServerMessageExtensions.schema(), ClientMessageExtensions.schema(), Port(7700));
    store.dispatch(Start(slob));


    slob.incoming
      .next(function (incoming: IncomingMessage<common.ClientMessage>) {
        switch incoming {
          case Connected(client):
            trace("A client connected!");
            slob.send(client, UsernamePrompt);
          case Invalid(client, orig, parseError):
            trace(parseError);
            slob.send(client, Error(FailureToParse(parseError)));
          case Message(connection, JoinLobby(user)):
            trace(user);
            store.dispatch(LobbyAction(User.fromClientUser(user, connection), Join));
        }
      })
      // TODO: .error()
      // TODO: .done()
      .run();
  }
}
