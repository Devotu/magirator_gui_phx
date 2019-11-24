defmodule MagiratorGuiPhxWeb.DeckController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorStore.Structs.Deck
  alias MagiratorGuiPhx.Helpers.Statistics
  alias MagiratorGuiPhx.Helpers.Rating
  alias MagiratorGuiPhx.Helpers.Collection
  alias MagiratorGuiPhxWeb.Helpers.Helper

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
    startStamp = :erlang.timestamp()

    {:ok, deck} = MagiratorStore.get_deck(id)
    {:ok, results} = MagiratorStore.list_results_by_deck(id)
    result_summary = MagiratorCalculator.summarize_places(results)
    statistical_data = Statistics.summarize_result_summary(result_summary)
    rating_data = Rating.rate_all_result_summary(result_summary)

    {:ok, list_results} = MagiratorQuery.list_deck_results(id)
    grouped_list_results = Collection.group_list_results_by_match(list_results)

    endStamp = :erlang.timestamp()
    time_taken = (:timer.now_diff endStamp, startStamp)/1000/1000
    IO.puts("Time to fetch and calculate deck data: #{time_taken}")

    render conn, "show.html", %{
      deck: deck, 
      statistical_data: statistical_data,
      rating_data: rating_data,
      matches: grouped_list_results,
      timing: time_taken
    }
  end
end