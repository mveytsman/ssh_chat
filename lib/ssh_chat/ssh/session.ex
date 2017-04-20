defmodule SshChat.SSH.Session do
  use GenServer

  # --- Client ---

  def start_session(user, addr) do
    # starts a session via supervisor
    {:ok, session_pid} = Supervisor.start_child(SshChat.SSH.Session.Supervisor, [user, addr])
    spawn fn -> initialize_io_loop(user, addr, session_pid) end
  end

  def send_message(pid, msg) do
    GenServer.cast(pid, {:message, msg})
  end

  # --- Input Loop
  defp initialize_io_loop(user, addr, session_pid) do
    # If the listener dies, kill us and vice versa
    Process.link(session_pid)
    # Set the group leader of the session so it writes IO to the right place
    Process.group_leader(session_pid, Process.group_leader)

    IO.puts("Welcome to Elixir SshChat #{user}! #{Mix.Project.config[:version]}")
    SshChat.SSH.Session.input_loop({user, addr, session_pid})
  end

  def input_loop({user, _addr, pid} = state) do
    case IO.gets("<#{user}> ") do
      :eof ->
        # I assumed that sending a ^D would get me this, but it's trapped somehow and I never see its
        IO.puts("Goodbye! (eof)")

      {:error, :interrupted} ->
        # Right now ^C is the only way to exit
        IO.puts("Goodbye! (interrupt)")
        GenServer.stop(pid, :normal)

      {:error, reason} ->
        IO.puts("Got an error: #{reason}")
        GenServer.stop(pid, {:error, reason})

      msg ->
        SshChat.SSH.Room.message(pid, String.trim(String.Chars.to_string(msg)))
        SshChat.SSH.Session.input_loop(state)

    end
  end


  # --- GenServer Client

  def start_link(user, addr) do
    GenServer.start_link(__MODULE__, {:ok, user, addr}, [])
  end

  # --- GenServer Callbacks ---

  def init({:ok, user, _addr}) do
    # user is a charlist, we want strings
    SshChat.SSH.Room.register(self(), "#{user}")
    {:ok, []}
  end

  def handle_cast({:message, msg}, state) do
    IO.puts(msg)
    {:noreply, state}
  end
end
