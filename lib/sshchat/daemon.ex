defmodule SSHChat.Daemon do
  @key_dir './ssh_dir' #this *has* to be a charlist because erlang

  def start_link do
    port = Application.get_env(:sshchat, :port)
    :ssh.daemon(port,
      system_dir: @key_dir,
      key_cb: SSHChat.NopKeyApi,
      shell: &SSHChat.Session.start_session(&1,&2),
      parallel_login: true,
      max_sessions: 100000, # how many can I take?
    )
  end
end
