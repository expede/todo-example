defmodule TodoWeb.EventSocket do
  use Phoenix.Socket

  ## Channels
  channel "event:*", TodoWeb.EventChannel

  ## Transports
  transport :longpoll, Phoenix.Transports.LongPoll
  transport :websocket, Phoenix.Transports.WebSocket,
    timeout: 45_000

  def connect(_params, socket), do: {:ok, socket}

  def id(_socket), do: nil
end
