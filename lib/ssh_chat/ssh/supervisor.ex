defmodule SSHChat.SSH.Supervisor do
  use Supervisor

  @name SSHChat.SSH.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(SSHChat.SSH.Daemon, []),
      supervisor(SSHChat.SSH.Session.Supervisor, []),
      worker(SSHChat.SSH.Room, []),
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
