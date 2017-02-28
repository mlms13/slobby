package common;

import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

import common.types.Lobby;
import common.types.User;

enum ClientMessage {
  CreateLobby(user: User);
  JoinLobby(lobby: LobbyId, user: User);
}

class ClientMessageExtensions {
  public static function schema<E>(): Schema<E, ClientMessage> return oneOf([
    makeAlt("createLobby", CreateLobby, User.schema().schema),
    // makeAlt("joinLobby", JoinLobby, {
    //   lobby: string().schema, // TODO: string().schema is wrong
    //   user: User.schema().schema
    // })
  ]);
}
