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

const printEvent = (type, message, containerId = "events") => {
  const eventsWrapper = document.getElementById(containerId);

  const newEventEl = document.createElement("li");
  newEventEl.className = "container";

  const header = document.createElement("mark");
  header.innerText = `[${type}] `;
  newEventEl.appendChild(header);

  const body = document.createTextNode(message);
  newEventEl.appendChild(body);

  eventsWrapper.insertBefore(newEventEl, eventsWrapper.firstChild);
};

socket.connect();

document.addEventListener('DOMContentLoaded', () => {
  const channel = socket.channel("event:lobby");

  channel
    .join()
    .receive("error", err => console.error("Join failed", err))
    .receive("ok", resp => {
      console.log("Attached to todo event stream");
      printEvent("info", "Beginning of stream");
    });

  channel.on("new", ({type, id, name}) => {
    printEvent(type, `Added ${name}`);
  });

  channel.on("change", ({type, id, name, changes}) => {
    printEvent(type, `Updated ${name}'s fields: ${changes.join(", ")}`);
  });

  channel.on("delete", ({type, id, name, changes}) => {
    printEvent(type, `Deleted ${name}`);
  });
}, false);
