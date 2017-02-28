package common;

import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

import common.types.Lobby;
import common.types.User;

enum ErrorMessage {
  AuthRequired;
  LobbyFull;
  Unrecognized(err: String);
}

enum LobbyMessage {
  UserJoined(user: User);
  UserDisconnected(user: User);
}

enum ServerMessage {
  Error(msg: ErrorMessage);
  Lobby(lobby: Lobby, msg: LobbyMessage);
  Game; // TODO
}

class ServerMessageExtensions {
  static function errorMessageSchema<E>(): Schema<E, ErrorMessage> return oneOf([
    makeAlt("authRequired", AuthRequired),
    makeAlt("lobbyFull", LobbyFull),
    makeAlt("unrecognized", Unrecognized, string().schema)
  ]);

  public static function schema<E>(): Schema<E, ServerMessage> return oneOf([
    makeAlt("error", Error, errorMessageSchema().schema)
  ]);
}
