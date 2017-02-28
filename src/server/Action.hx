import common.types.User;
import common.types.Lobby;

// These are actions that cause the state to update. They are generally
// triggered by a client.
enum Action {
  Start(wss: npm.ws.Server);
  LobbyAction(action: LobbyAction);
}

enum LobbyAction {
  CreateLobby(owner: User, size: Int);
  JoinLobby(user: User, lobby: LobbyId);
  DestroyLobby(lobby: LobbyId);
}
