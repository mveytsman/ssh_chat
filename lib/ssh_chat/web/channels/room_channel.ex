defmodule SSHChat.Web.RoomChannel do
  use SSHChat.Web, :channel
  alias SSHChat.SSH.Room, as: SSHRoom

  def join("room:lobby", _payload, socket) do
    {:ok, socket}
  end
  
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "Unauthorized"}}
  end
  
  def handle_in("new_msg", %{"id" => id, "user" => user, "body" => body}, socket) do
    SSHRoom.message(user, body)
    broadcast! socket, "new_msg", %{id: id, user: user, body: body}
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end
end