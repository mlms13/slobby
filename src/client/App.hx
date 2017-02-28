import js.html.WebSocket;
import thx.stream.Property;
import thx.stream.Store;

class App {
  public static function main() {
    var state: State = NotConnected;
    var prop = new Property(state);
    var store = new Store(prop, Reducer.reduce, thx.stream.Reducer.Middleware.empty());
    var socket = new WebSocket("ws://localhost:7700");

    socket.addEventListener("open", function (_) {
      socket.send("This is my message");
    });
  }
}
