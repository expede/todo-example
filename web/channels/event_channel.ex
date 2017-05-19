defmodule Todo.EventChannel do
  use Todo.Web, :channel
  require Logger

  # ==== #
  # Send #
  # ==== #

  def broadcast_create(model) do
    data = %{
      id: model.id,
      name: model.name,
      type: model.__struct__.__schema__(:source)
    }

    Todo.Endpoint.broadcast("event:lobby", "new", data)
  end

  def broadcast_update(%{data: model, changes: changes} = _changeset) do
    changed_fields =
      Enum.filter_map(
        changes,
        fn {key, value} -> not is_list(value) || Map.get(model, key) != value end,
        fn {key, _}   -> key end
      )

    data = %{
      id: model.id,
      name: model.name,
      type: model.__struct__.__schema__(:source),
      changes: changed_fields
    }

    Todo.Endpoint.broadcast("event:lobby", "change", data)
  end

  def broadcast_destroy(model) do
    data = %{
      id: model.id,
      name: model.name,
      type: model.__struct__.__schema__(:source)
    }

    Todo.Endpoint.broadcast("event:lobby", "delete", data)
  end

  # ======= #
  # Receive #
  # ======= #

  def join("event:lobby" = channel, payload, socket) do
    {:ok, "Connected to socket #{channel}!", socket}
  end

  def handle_in("event:new", %{name: name, list: %{name: list_name}}, socket) do
    broadcast(socket, "item:new", %{name: name, list_name: list_name})
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (event:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end
end
