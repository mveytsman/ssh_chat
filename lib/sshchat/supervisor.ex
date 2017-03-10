defmodule SSHChat.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(SSHChat.Daemon, []),
      worker(SSHChat.Room, []),
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
