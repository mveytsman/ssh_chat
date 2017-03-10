defmodule SSHChat.Session do
  use GenServer

  # --- Client ---

  def start_link(user, addr) do
   # spawn fn -> IO.puts("start link") end
    spawn fn ->
      {:ok, pid} = GenServer.start(__MODULE__, {:ok, user, addr}, [])
      input_loop({user, addr, pid})
    end
  end

  def send_message(pid, message) do
    GenServer.cast(pid, {:message, message})
  end

  # --- Callbacks ---

  def init({:ok, user, _addr}) do
    IO.puts("Welcome to Elixir SSHChat #{user}!")
    SSHChat.Room.register(self(), user)
    {:ok, []}
  end

  def handle_cast({:message, msg}, state) do
    IO.puts(msg)
    {:noreply, state}
  end

  def input_loop({user, _addr, pid} = state) do
    case IO.gets("<#{user}> ") do
      :eof ->
        # I assumed that sending a ^D would get me this, but it's trapped somehow and I never see its
        SSHChat.Room.unregister(pid)
        IO.puts("Goodbye! (eof)")

      {:error, :interrupted} ->
        # Right now ^C is the only way to exit
        SSHChat.Room.unregister(pid)
        IO.puts("Goodbye! (interrupt)")

      {:error, reason} ->
        SSHChat.Room.unregister(pid)
        IO.puts("Got an error: #{reason}")

      s ->
        SSHChat.Room.send_from(pid, String.trim(String.Chars.to_string(s)))
        input_loop(state)
    end
  end
end
