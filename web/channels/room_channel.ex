defmodule Todo.ListChannel do
  use Todo.Web, :channel
  require Logger

  def join("list:" <> room_id, _params, socket) do
    Logger.info("NEW BUDDY #{room_id}")
    {:ok, assign(socket, :room_id, room_id)}
  end
end
