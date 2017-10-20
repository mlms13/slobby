package common;

import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

import common.types.Lobby;
import common.types.ClientUser;

enum ErrorMessage {
  AuthRequired;
  LobbyFull;
  Invalid(err: String); // catch all other invalid actions
  FailureToParse(err: String); // failure to parse client message
}

enum LobbyMessage {
  UserJoined(user: ClientUser);
  UserDisconnected(user: ClientUser);
}

enum ServerMessage {
  UsernamePrompt;
  Error(msg: ErrorMessage);
  Lobby(lobby: Lobby, msg: LobbyMessage);
  Game; // TODO
}

class ServerMessageExtensions {
  static function errorMessageSchema<E>(): Schema<E, ErrorMessage> return oneOf([
    makeAlt("lobbyFull", LobbyFull),
    makeAlt("invalid", Invalid, string().schema),
    makeAlt("failureToParse", FailureToParse, string().schema)
  ]);

  public static function schema<E>(): Schema<E, ServerMessage> return oneOf([
    makeAlt("usernamePrompt", UsernamePrompt),
    makeAlt("error", Error, errorMessageSchema().schema),
    // TODO ...
  ]);
}
