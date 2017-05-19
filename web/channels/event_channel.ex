defmodule Todo.EventChannel do
  use Todo.Web, :channel
  require Logger

  def join("event:feed", _params, socket) do
    Logger.info("NEW BUDDY")
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_in("new_event", params, socket) do

  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "Ping!", %{count: count})
    {:noreply, assign(socket, :count, count + 1)}
  end
end
