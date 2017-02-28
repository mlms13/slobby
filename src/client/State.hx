enum State {
  NotConnected;
  FailedConnection;
  Connected(socket: js.html.WebSocket);
}
