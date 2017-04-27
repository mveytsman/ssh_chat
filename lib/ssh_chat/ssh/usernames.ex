defmodule SshChat.SSH.Usernames do
  # This is dumb

  @name __MODULE__

  def start_link do
    Agent.start_link(fn -> Map.new end, name: @name)
  end

  def add(name, username) do
    Agent.update(@name, &Map.put(&1, name, username))
  end

  def get(name) do
    Agent.get_and_update(@name, &Map.pop(&1, name))
  end

  def get_all do
    Agent.get(@name, fn x -> x end)
  end
end
