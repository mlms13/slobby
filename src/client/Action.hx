import common.types.User;
import common.types.Lobby;

enum Action {
  Authenticate(name: String);
  CreateLobby(as: User);
  JoinLobby(id: LobbyId);
}
