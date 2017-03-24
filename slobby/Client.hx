package slobby; // TODO: move to slobby.client;

import js.html.WebSocket;

import thx.Either;
using thx.Eithers;
import thx.schema.SimpleSchema;
import thx.schema.SchemaDynamicExtensions;
import thx.stream.Stream;

class Client<SMsg, CMsg> {
  public var incoming(default, null): Stream<IncomingMessage<SMsg>>;
  var sMsgSchema: Schema<String, SMsg>;
  var cMsgSchema: Schema<String, CMsg>;
  var client: WebSocket;

  function new(sMsgSchema, cMsgSchema, client: WebSocket) {
    this.sMsgSchema = sMsgSchema;
    this.cMsgSchema = cMsgSchema;
    this.client = client;

    this.incoming = Stream.create(function (subj) {
      client.addEventListener("message", function (msg: js.html.MessageEvent) {
        // TODO: better parsing of {} from stringified JSON
         try {
            switch SchemaDynamicExtensions.parseDynamic(sMsgSchema, thx.Functions.identity, haxe.Json.parse('${msg.data}')) {
              case Left(e): subj.message(Next(Invalid('${msg.data}', '$e'))); // TODO: error
              case Right(v): subj.message(Next(Message(v)));
            }
          } catch (e: Dynamic) {
            trace(e);
            subj.message(Next(Invalid('$msg', 'Message could not be parsed as JSON: $e')));
          }
      });
    });
  }

  /**
   *  Attempts to create a slobby.Client, connected to the provided `url`.
   *  This returns `Left(message)` if the connection throws during creation,
   *  or `Right(slobby.Client)` if things work.
   */
  public static function create<SMsg, CMsg>(sMsgSchema, cMsgSchema, url: String): Either<String, Client<SMsg, CMsg>> {
    var ws = try {
      Right(new WebSocket(url));
    } catch (e: Dynamic) {
      Left('Failed to create socket connection. ${e.message}');
    };

    return ws.map(function (socket) {
      return new Client(sMsgSchema, cMsgSchema, socket);
    });
  }
}

enum IncomingMessage<SMsg> {
  Invalid(orig: String, parseError: String); // TODO
  Message(msg: SMsg);
}
