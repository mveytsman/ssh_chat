defmodule SshChat.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(SshChat.Repo, []),
      # Start the endpoint when the application starts
      supervisor(SshChat.Web.Endpoint, []),
      # Start your own worker by calling: SshChat.Worker.start_link(arg1, arg2, arg3)
      # worker(SshChat.Worker, [arg1, arg2, arg3]),
      supervisor(SshChat.SSH.Supervisor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SshChat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
