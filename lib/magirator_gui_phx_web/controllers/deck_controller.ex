defmodule MagiratorGuiPhxWeb.DeckController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorStore.Structs.Deck
  alias MagiratorGuiPhx.Helpers.CollectorHelper, as: Collector
  alias MagiratorGuiPhxWeb.Helpers.GeneralHelper, as: Helper

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"new_deck" => deck_params}) do
    atom_deck = Helper.atomize_keys deck_params
    deck = struct(Deck, atom_deck)
    player_id = deck_params["player_id"]

    {:ok, _id} = MagiratorStore.create_deck(deck, player_id)

    conn
    |> redirect(to: main_path(conn, :main))
  end

  def index(conn, _params) do
    {:ok, decks} = MagiratorStore.list_decks()
    render conn, "list.html", decks: decks
  end

  def show(conn, %{"id" => id}) do
    {:ok, startStamp} = DateTime.now("Etc/UTC")

    {:ok, deck} = MagiratorStore.get_deck id
    {:ok, game_results} = MagiratorStore.list_results_by_deck(id)
    {:ok, results} = MagiratorQuery.find_deck_results(id)
    {:ok, extended_results} = MagiratorQuery.extend_results_visual(game_results) 

    statistical_data = Collector.collect_game_statistics(results)    
    rating_data = Collector.collect_rating_data(results)

    {:ok, endStamp} = DateTime.now("Etc/UTC")
    time_taken = DateTime.diff(startStamp, endStamp)
    IO.puts("Time to fetch deck data: #{time_taken}")

    render conn, "show.html", %{
      deck: deck, 
      statistical_data: statistical_data,
      rating_data: rating_data,
      matches: extended_results,
      timing: time_taken
    }
  end
end