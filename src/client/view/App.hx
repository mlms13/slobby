package view;

import doom.html.Html.*;
import common.ClientMessage;
import common.types.ClientUser;
import State;

class App {
  public static function render(state: State) {
    return div([
      header([
        h1("Socket Lobby")
      ]),
      section(switch state {
        case NotConnected: h3("Connecting");
        case FailedConnection(err): h3("Error: " + err);
        case Connected(socket, state): renderApp(state, function (cmsg: ClientMessage) {
          socket.send(cmsg);
        });
      })
    ]);
  }

  static function renderApp(appState: AppState, send: ClientMessage -> Void) return switch appState {
    case Initial: h3("Awaiting server instructions"); // TODO: loader
    case LoginForm: new Form({ submit: function (username) {
      send(JoinLobby(new ClientUser(username)));
    }}).asNode();
    case Lobby: h1("whoa");
  }

}

class Form extends doom.html.Component<{ submit: String -> Void }> {
  public override function render() {
    return form([
      "submit" => onsubmit
    ], [
      input([
        "type" => "text",
        "placeholder" => "Enter a username",
      ]),
      button([ "type" => "submit" ], "Go")
    ]);
  }

  function onsubmit() {
    var input: js.html.InputElement = cast element.querySelector("input");
    props.submit(input.value);
  }
}
