defmodule SSHChat do
  @moduledoc """
  Documentation for SSHChat.
  """

  @port 2222
  @key_dir './ssh_dir' #this *has* to be a charlist because erlang

  def start do
    # TODO: This will eventually be an application!
    SSHChat.Room.start_link()
    
    :ssh.daemon(@port,
      system_dir: @key_dir,
      key_cb: SSHChat.NopKeyApi,
      shell: &SSHChat.Session.start_link(&1,&2),
      parallel_login: true,
      max_sessions: 100000, # how many can I take?
    )
  end

end
