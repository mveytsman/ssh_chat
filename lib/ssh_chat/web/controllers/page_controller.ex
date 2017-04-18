defmodule SshChat.Web.PageController do
  use SshChat.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
