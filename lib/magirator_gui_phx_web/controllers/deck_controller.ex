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
    {:ok, deck} = MagiratorStore.get_deck(id)    
    {:ok, list_results} = MagiratorQuery.list_deck_results(id)

    statistical_data = Statistics.summarize_results(list_results)
    rating_data = Rating.rate_results(list_results)
    grouped_list_results = Collection.group_list_results_by_match(list_results)

    render conn, "show.html", %{
      deck: deck, 
      statistical_data: statistical_data,
      rating_data: rating_data,
      matches: grouped_list_results
    }
  end
end