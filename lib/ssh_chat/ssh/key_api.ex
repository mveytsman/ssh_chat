require IEx
defmodule SshChat.SSH.KeyApi do
  @moduledoc """
  Checks to see if we know the key
  """

  alias SshChat.Auth
  alias SshChat.SSH.Usernames

  @behaviour :ssh_server_key_api

  def host_key(algorithm, props) do
    # delegate to the ssh file key api
    :ssh_file.host_key(algorithm, props)
  end

  def is_auth_key(key, ssh_username, _options) do
    user = :public_key.ssh_encode([{key, []}], :openssh_public_key)
    |> String.strip
    |> Auth.get_user_by_key

    if is_nil(user) do
      false
    else
      Usernames.add(ssh_username, user.nick)
      true
    end
  end

end
