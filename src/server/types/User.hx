package types;

import npm.WebSocket;
import common.types.ClientUser;

class User {
  public var name(default, null): String;
  public var connection(default, null): WebSocket;

  public function new(name: String, connection: WebSocket) {
    this.name = name;
    this.connection = connection;
  }

  public static function fromClientUser(client: ClientUser, connection: WebSocket) {
    return new User(client.name, connection);
  }
}
