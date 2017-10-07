import {Socket} from "phoenix";

const socket = new Socket("/socket", {
  params: {},
  logger: (kind, msg, data) => {
    console.log(`${kind}: ${msg}`, data);
  }
});

export default socket;
