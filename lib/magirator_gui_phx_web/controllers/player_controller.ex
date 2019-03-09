defmodule MagiratorGuiPhxWeb.PlayerController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorStore.Helpers

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"new_player" => player_params}) do
    atom_player = Helpers.atomize_keys player_params

    hashword = :crypto.hash( :sha512, atom_player.password ) 
    |> Base.encode16
    |> String.downcase

    {:ok, user_id} = MagiratorStore.create_user(atom_player.email, hashword)
    {:ok, player_id} = MagiratorStore.create_player(atom_player.name, user_id)

    conn
    |> redirect(to: main_path(conn, :main))
  end
end