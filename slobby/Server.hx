package slobby;

import npm.WebSocket;

import thx.schema.SimpleSchema;
import thx.schema.SchemaDynamicExtensions;
import thx.stream.Stream;

class Server<SMsg, CMsg> {
  public var incoming: Stream<IncomingMessage<CMsg>>;

  var sMsgSchema: Schema<String, SMsg>;
  var cMsgSchema: Schema<String, CMsg>;
  var server: npm.ws.Server;

  function new(sMsgSchema, cMsgSchema, server) {
    this.sMsgSchema = sMsgSchema;
    this.cMsgSchema = cMsgSchema;
    this.server = server;

    incoming = Stream.create(function (subj) {
      server.on("connection", function (ws: npm.WebSocket) {
        ws.on("message", function (msg: Dynamic) { // TODO: is buffer a thing we have to worry about
           try {
            switch SchemaDynamicExtensions.parseDynamic(cMsgSchema, thx.Functions.identity, haxe.Json.parse(msg.toString())) {
              case Left(e): subj.message(Next(Invalid(ws, '$msg', '$e'))); // TODO: error
              case Right(v): subj.message(Next(Message(ws, v)));
            }
          } catch (e: Dynamic) {
            subj.message(Next(Invalid(ws, msg, "Message could not be parsed as JSON")));
          }
        });
        subj.message(Next(Connected(ws)));
      });
    });
  }

  public function broadcast(clients: Array<WebSocket>, msg: SMsg) {
    thx.Arrays.each(clients, send.bind(_, msg));
  }

  public function send(client: WebSocket, msg: SMsg) {
    var msgObj = SchemaDynamicExtensions.renderDynamic(sMsgSchema, msg);
    client.send(haxe.Json.stringify(msgObj));
  }

  /**
   *  Creates and starts a new websocket server.
   */
  public static function create<SMsg, CMsg>(sMsgSchema, cMsgSchema, connection: ServerConnection): Server<SMsg, CMsg> {
    return new Server(sMsgSchema, cMsgSchema, switch connection {
      case Port(port): new npm.ws.Server({ port: port });
      case HttpsServer(server): new npm.ws.Server({ server: server });
      case HttpServer(server): new npm.ws.Server({ server: server });
      case NoServer: new npm.ws.Server({ noServer: true });
    });
  }
}

enum ServerConnection {
  Port(port: Int);
  HttpsServer(server: js.node.https.Server);
  HttpServer(server: js.node.http.Server);
  NoServer;
}

enum IncomingMessage<CMsg> {
  Connected(client: WebSocket);
  Invalid(client: WebSocket, orig: String, parseError: String); // TODO: error type
  Message(client: WebSocket, msg: CMsg);
}
