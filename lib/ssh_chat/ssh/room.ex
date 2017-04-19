defmodule SSHChat.SSH.Room do
  alias SSHChat.Web.Endpoint, as: WebEndpoint
  @moduledoc """
  The users connected to the chat room

  There is only one room
  """

  use GenServer

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def register(pid, name) do
    # let's say for now that the user list is going to be a map from peer addresses to pods
    announce("#{name} joined")
    GenServer.cast(@name, {:register, pid, name})
  end

  def unregister(pid) do
    name = GenServer.call(@name, {:unregister, pid})
    announce("#{name} left")
  end

  def announce(message) do
    GenServer.cast(@name, {:announce, message})
  end

  def message(from, message) do
    GenServer.cast(@name, {:message, from, message})
  end

  # --- Callbacks ---

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:unregister, pid}, _from, sessions) do
    {name, sessions} = Map.pop(sessions, pid)
    {:reply, name, Map.delete(sessions, name)}
  end

  def handle_cast({:register, pid, name}, sessions) do
    Process.monitor(pid)
    {:noreply, Map.put(sessions, pid, name)}
  end

  def handle_cast({:announce, message}, sessions) do
    WebEndpoint.broadcast("room:lobby", "new_msg", %{user: "CHANNEL", body: message})
    Map.keys(sessions)
    |> Enum.each(fn(pid) -> SSHChat.SSH.Session.send_message(pid, " * #{message}") end)
    {:noreply, sessions}
  end

  def handle_cast({:message, from, message}, sessions) do
    # TODO: refactor this
    {name, others} = cond do
      is_pid(from) -> 
        {name, others} = Map.pop(sessions, from)
        WebEndpoint.broadcast("room:lobby", "new_msg", %{user: name, body: message})
        {name, others}
      :else -> {from, sessions}
    end
    
    others
    |> Map.keys
    |> Enum.each(fn(pid) -> SSHChat.SSH.Session.send_message(pid, "#{name}: #{message}") end)
    {:noreply, sessions}
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, sessions) do
    {name, sessions} = Map.pop(sessions, pid)
    announce("#{name} left")
    {:noreply, sessions}
  end

end
