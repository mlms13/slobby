import common.types.Lobby;

enum State {
  Starting;
  Running(wss: npm.ws.Server, lobbies: Array<Lobby>);
}
