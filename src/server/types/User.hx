package server.types;

import npm.WebSocket;

class User {
  public var name(default, null): String;
  public var connection(default, null): WebSocket;

  public function new(name: String, connection: WebSocket) {
    this.name = name;
    this.connection = connection;
  }
}
