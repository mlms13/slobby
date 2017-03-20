package common.resistance;

import thx.Tuple;
import common.types.ClientUser;

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

// used for votes, mission outecomes
enum Result {
  Success;
  Failure;
}
