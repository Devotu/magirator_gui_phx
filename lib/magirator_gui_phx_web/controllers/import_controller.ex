defmodule MagiratorGuiPhxWeb.ImportController do
  use MagiratorGuiPhxWeb, :controller

  alias MagiratorGuiPhx.Logic.DataImport

  def new(conn, %{"error" => error}) do
    render conn, "new.html", %{error: error}
  end

  def new(conn, %{"result" => result}) do
    render conn, "new.html", %{result: result}
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def import(conn, %{"import_data" => %{"player_id" => player_id, "data" => data}}) do

    parsed_data = Poison.decode(~s(#{data}))

    IO.inspect(parsed_data)

    case parsed_data do
      {:error, msg} ->
        display_error(conn, msg)
      {:ok, map_data} ->
        import_data(conn, map_data, player_id)
      _ -> 
        display_error(conn, "Unknown error")
    end
  end

  def import(conn, _params) do
    redirect(conn, to: import_path(conn, :new))
  end

  defp import_data(conn, map_data, player_id) do
    map_decks = map_data["decks"]
    {:ok, deck_id_list} = DataImport.import_decks(map_decks, player_id)
    IO.inspect(deck_id_list, label: "imported decks")

    map_games = map_data["games"]
    IO.inspect(map_games, label: "map games")
    {:ok, game_id_list} = DataImport.import_games(map_games, player_id)
    IO.inspect(deck_id_list, label: "imported games")

    redirect(conn, to: import_path(conn, :new, result: "imported decks: #{Kernel.inspect(deck_id_list)} and games: #{game_id_list}"))
  end

  defp display_error(conn, msg) do
    IO.inspect("error #{Kernel.inspect(msg)}")
    redirect(conn, to: import_path(conn, :new, error: "invalid json"))
  end
end