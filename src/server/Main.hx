import npm.ws.Server;
using thx.Functions;
import thx.Functions.identity;
using thx.schema.SchemaDynamicExtensions;
import thx.stream.Property;
import thx.stream.Store;

import common.ClientMessage;
import common.ServerMessage;

class Main {
  public static function main() {
    var state: State = Starting;
    var prop = new Property(state);
    var store = new Store(prop, Reducer.reduce, thx.stream.Reducer.Middleware.empty());

    var wss = new Server({ port: 7700 });

    store.dispatch(Start(wss));

    wss.on("connection", function (ws) {
      ws.on("message", function (message: Dynamic) {
        var parsed = ClientMessageExtensions.schema().parseDynamic(identity, message);
        switch parsed.leftMap(function (errs) return errs.map.fn(_.error)) {

          // TODO: don't use ws.send directly
          case Left(err):
            var response = ServerMessage.Error(Unrecognized(err.toArray().join(" ")));
            ws.send(haxe.Json.stringify(
              SchemaDynamicExtensions.renderDynamic(ServerMessageExtensions.schema(), response)
            ));

          // TODO: update state
          case Right(msg): trace(msg);
        }
      });
    });
  }
}