// enum GamePhase {
//   // initially empty while we wait for selections from the leader
//   // slowly populated with their choices. when game rules determine
//   // the selection is complete, prompt for votes.
//   ChooseMissionMembers(players: Array<Player>);
//   Mission(players: Array<Player>);
//   // Inquisition;
// }

enum GameState {
  Lobby(players: Array<User>); // waiting for sufficient player count
  Game(gamePhase: GamePhase);
}

// actions that players take, can have partial information
enum Turn {
  ChoosingMissionMembers(members: Array<User>);
  Voting(members: Array<User>, votes: Array<Tuple<Users, Result>>);
}

// complete mission/vote, used for historical logs
enum Round {
  MissionRejected(votes: Array<Tuple<User, Result>>, proposed: Array<User>);
  MissionAccepted(votes: Array<Tuple<User, Result>>, outcomes: Array<Tuple<User, Result>>);
}

// has all the info, lives on the server
class GamePhase {
  var players: Array<Player>;
  var leader: User;
  var turn: Turn; // info from clients (choosing members, voting)
  var rounds: Array<Round>; // everything so far
}


class Mission {
  var playerActions: Array<Tuple<User, Result>>; // TODO? typedef?

  public function outcome(rules: {}, round: Int): Result { // TODO
    return Success;
  }
}

// used for votes, mission outecomes
enum Result {
  Success;
  Failure;
}


class Player {
  var user: User;
  var role: PlayerRole;
}

enum PlayerRole {
  Spy;
  Resistance;
  // Merlin
  // Assassin
}







typedef ClientUser = User; // probably a subset of server users

enum ClientPlayerRole {
  Spy(otherSpies: Array<ClientUser>);
  Resistance;
}

enum ClientGameState {
  Lobby(players: Array<ClientUser>);
  Game(gamePhase: ClientGamePhase);
}

enum ClientTurn {
  ChoosingMissionMembers(members: Array<ClientUser>);
  Voting(members: Array<ClientUser>, votes: Array<ClientUser>);
}

enum ClientRound {
  MissionRejected(votes: Array<Tuple<ClientUser, Result>>, proposed: Array<ClientUser>);
  MissionAccepted(votes: Array<Tuple<ClientUser, Result>>, outcome: Array<Result>);
}

class ClientGamePhase {
  var role: ClientPlayerRole;
  var players: Array<ClientUser>;
  var leader: ClientUser;
  var turn: ClientTurn;
  var rounds: Array<ClientRound>;
}
