require IEx
defmodule SshChat.Web.AuthController do

  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """
  use SshChat.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias SshChat.Auth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = Auth.get_or_create_user_by_ueberauth(auth)

    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:current_user, user)
    |> redirect(to: "/")
  end
end
