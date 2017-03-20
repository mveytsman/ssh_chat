defmodule SSHChat.Supervisor do
  use Supervisor

  @name SSHChat.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(SSHChat.Daemon, []),
      supervisor(SSHChat.Session.Supervisor, []),
      worker(SSHChat.Room, []),
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
