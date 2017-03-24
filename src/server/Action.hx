import common.ServerMessage;
import common.ClientMessage;
import types.User;

// These are actions that cause the state to update. They are generally
// triggered by a client.
enum Action {
  Start(server: slobby.Server<ServerMessage, ClientMessage>);

  // TODO: turn these into UserAction?
  LobbyAction(who: User, action: LobbyAction);
  GameAction(who: User, action: GameAction);
}

enum LobbyAction {
  // Create(owner: User, size: Int);
  Join(/*lobby: LobbyId*/);
  // Destroy(lobby: LobbyId);
}

enum GameAction {
  Vote; // TODO: lots more than this
}
