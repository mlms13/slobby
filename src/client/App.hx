import thx.stream.Property;
import thx.stream.Store;

import haxe.ds.Option;
import slobby.Client;
import common.ClientMessage;
import common.ServerMessage;
import Action;

class App {
  public static function main() {
    var state: State = NotConnected;
    var prop = new Property(state);
    var store = new Store(prop, Reducer.reduce, thx.stream.Reducer.Middleware.empty());
    var client = Client.create(ServerMessageExtensions.schema(), ClientMessageExtensions.schema(), "ws://localhost:7700");

    client.incoming
      .filterMap(function (msg: IncomingMessage<ServerMessage>): Option<Action> {
        trace(msg);
        return switch msg {
          case Invalid(orig, err): None;
          case Message(msg): Some(ServerAction(msg));
        }
      })
      .next(function (action) {
        store.dispatch(action);
      })
      .run();
  }
}
