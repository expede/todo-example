import "phoenix_html";

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
