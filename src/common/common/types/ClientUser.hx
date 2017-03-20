package common.types;

import thx.schema.SchemaDSL.*;
import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

class ClientUser {
  public var name(default, null): String;

  public function new(name) {
    this.name = name;
  }

  public static function schema<E>(): Schema<E, ClientUser> return object(
    ap1(
      ClientUser.new,
      required("name", string(), function (u: ClientUser) return u.name)
    )
  );
}
