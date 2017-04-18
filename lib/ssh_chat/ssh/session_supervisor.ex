defmodule SSHChat.SSH.Session.Supervisor do
  use Supervisor

  @name SSHChat.SSH.Session.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(SSHChat.SSH.Session, [], restart: :temporary),
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

 end
