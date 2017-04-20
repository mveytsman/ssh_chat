defmodule SshChat.SSH.Supervisor do
  use Supervisor

  @name SshChat.SSH.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(SshChat.SSH.Daemon, []),
      supervisor(SshChat.SSH.Session.Supervisor, []),
      worker(SshChat.SSH.Room, []),
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
