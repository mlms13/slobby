package types;

import thx.Tuple;
import common.resistance.Types;

enum GameState {
  Lobby(players: Array<User>); // waiting for sufficient player count
  Game(phase: GamePhase);
}

// actions that players take, can have partial information
enum Turn {
  ChoosingMissionMembers(members: Array<User>);
  Voting(members: Array<User>, votes: Array<Tuple<User, Result>>);
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
