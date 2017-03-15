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
        ws.on("message", function (msg: Dynamic) {

        });
        subj.message(Next(Connected(ws)));
      });
    });
  }

  public function broadcast(msg: SMsg) {
    // TODO: send to
    // server.send(server.clients, msg.toString());
  }

  public function send(client: WebSocket, msg: SMsg) {
    var msgObj = SchemaDynamicExtensions.renderDynamic(sMsgSchema, msg);
    client.send(haxe.Json.stringify(msgObj));
  }

  /**
   *  Creates and starts a new websocket server.
   */
  public static function create<SMsg, CMsg, Err>(sMsgSchema, cMsgSchema, connection: ServerConnection): Server<SMsg, CMsg> {
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
