package common.types;

import thx.schema.SchemaDSL.*;
import thx.schema.SimpleSchema;
import thx.schema.SimpleSchema.*;

class User {
  public var name(default, null): String;

  public function new(name) {
    this.name = name;
  }

  public static function schema<E>(): Schema<E, User> return object(
    ap1(
      User.new,
      required("name", string(), function (u: User) return u.name)
    )
  );
}
