package slobby;

import js.html.WebSocket;

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

  public static function create<SMsg, CMsg>(sMsgSchema, cMsgSchema, url: String) {
    return new Client(sMsgSchema, cMsgSchema, new WebSocket(url));
  }
}

enum IncomingMessage<SMsg> {
  Invalid(orig: String, parseError: String); // TODO
  Message(msg: SMsg);
}
