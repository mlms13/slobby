package common;

import haxe.ds.Option;
import thx.schema.SchemaDSL.*;
import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

import common.types.ClientUser;

enum ClientMessage {
  // CreateLobby(user: ClientUser, size: Int);
  JoinLobby(user: ClientUser/*, lobby: LobbyId*/);
}

class ClientMessageExtensions {
  public static function schema<E>(): Schema<E, ClientMessage> return oneOf([
    // makeAlt("createLobby", CreateLobby, {
    //   user: ClientUser.schema().schema,
    //   size: int().schema
    // }),
    alt(
      "joinLobby",
      object(
        ap1(
          function(x) return { user: x},
          required("user", ClientUser.schema(), function(x: {user:ClientUser}) return x.user)
        )
      ),
      function(x: {user: ClientUser}): ClientMessage
        return JoinLobby(x.user),
      function(x: ClientMessage): Option<{user: ClientUser}>
        return switch x {
          case JoinLobby(x): Some({user:x});
          case _: None;
        }
    )
  //   {
  //     lobby: string().schema, // TODO: string().schema is wrong
  //     user: ClientUser.schema().schema
  // }
  ]);
}
