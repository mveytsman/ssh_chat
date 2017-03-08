defmodule SSHChat.Room do
  @moduledoc """
  The users connected to the chat room
  """

  @name __MODULE__

  def start_link do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def register(pid, name) do
    # let's say for now that the user list is going to be a map from peer addresses to pids
    Agent.update(@name, &Map.put(&1, pid, name))
  end

  def unregister(pid) do
    Agent.update(@name, &Map.delete(&1, pid))
  end

  def inspect() do
    Agent.get(@name, fn(x) -> x end)
  end

  def get_name(pid) do
    Agent.get(@name, &Map.get(&1, pid))
  end

  def send_from(pid, message) do
    name = get_name(pid)
    #SSHChat.Session.send_message(pid, "<you> #{message}")
    Agent.get(@name, &Map.delete(&1, pid)) # send to everyone else
    |> Map.keys
    |> Enum.each fn(pid) -> SSHChat.Session.send_message(pid, "<#{name}> #{message}") end
    end
end
