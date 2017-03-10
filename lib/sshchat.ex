defmodule SSHChat do
  use Application
  def start(_type, _args) do
    SSHChat.Supervisor.start_link
  end
end
