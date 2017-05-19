// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket";

socket.connect();

if (window.listId) {
  const msgContainer = document.getElementById("msg-container");
  const msgInput     = document.getElementById("msg-input");
  const postButton   = document.getElementById("msg-submit");

  const listChannel  = socket.channel("list:" + 1);

  listChannel
    .join()
    .receive("ok", resp => console.log("Joined room", resp))
    .receive("error", err => console.error("Join failed", err));
}
