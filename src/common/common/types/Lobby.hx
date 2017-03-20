package common.types;

abstract LobbyId(String) {
  public function new()
    this = "FOO123"; // TODO

  public function toString(): String
    return this;
}

class Lobby {
  public var id(default, null): LobbyId; // doubles as a URL
  public var users(default, null): Array<ClientUser>;
  public var owner(default, null): ClientUser;
  public var maxSize(default, null): Int;

  function new(id, users, owner, maxSize) {
    this.id = id;
    this.users = users;
    this.owner = owner;
    this.maxSize = maxSize;
  }

  public static function create(user: ClientUser, maxSize: Int) {
    return new Lobby(new LobbyId(), [], user, maxSize);
  }
}
