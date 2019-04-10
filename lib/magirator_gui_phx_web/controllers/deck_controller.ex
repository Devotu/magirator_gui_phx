defmodule MagiratorGuiPhxWeb.DeckController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorStore.Structs.Deck
  alias MagiratorStore.Helpers

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"new_deck" => deck_params}) do
    atom_deck = Helpers.atomize_keys deck_params
    deck = struct(Deck, atom_deck)
    player_id = deck_params["player_id"]

    {:ok, id} = MagiratorStore.create_deck(deck, player_id)

    conn
    |> redirect(to: main_path(conn, :main))
  end

  def index(conn, _params) do
    {:ok, decks} = MagiratorStore.list_decks()
    render conn, "list.html", decks: decks
  end

  def show(conn, %{"id" => id}) do
    {:ok, deck} = MagiratorStore.get_deck id
    {:ok, game_results} = MagiratorStore.list_results_by_deck(id)
    {:ok, results} = MagiratorQuery.find_deck_results(id)
    winrate = MagiratorCalculator.calculate_winrate(results)
    statistical_data = %{games: Enum.count(game_results), winrate: winrate}

    render conn, "show.html", %{deck: deck, statistical_data: statistical_data}
  end
end