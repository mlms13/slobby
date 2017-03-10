import common.types.User;
import common.types.Lobby;
import common.ServerMessage;
import common.ClientMessage;

// These are actions that cause the state to update. They are generally
// triggered by a client.
enum Action {
  Start(server: slobby.Server<ServerMessage, ClientMessage>);
  LobbyAction(action: LobbyAction);
}

enum LobbyAction {
  CreateLobby(owner: User, size: Int);
  JoinLobby(user: User, lobby: LobbyId);
  DestroyLobby(lobby: LobbyId);
}
