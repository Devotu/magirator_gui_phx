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
    
    statistical_data = %{
      games: Enum.count(game_results), 
      wins: Enum.count( Enum.filter( game_results, &(&1.place == 1) ) ), 
      draws: Enum.count( Enum.filter( game_results, &(&1.place == 0) ) ), 
      losses: Enum.count( Enum.filter( game_results, &(&1.place > 1) ) ), 
      winrate: winrate
    }

    pdiff = MagiratorCalculator.calculate_pdiff(results)
    pdiff3 = MagiratorCalculator.calculate_pdiff_cap(results, 3)
    pdist2positive = MagiratorCalculator.calculate_pdist_positive(results, 2)
    pdist2 = MagiratorCalculator.calculate_pdist(results, 2)
    
    rating_data = %{
      pdiff: pdiff,
      pdiff3: pdiff3,
      pdist2positive: pdist2positive,
      pdist2: pdist2
    }

    render conn, "show.html", %{
      deck: deck, 
      statistical_data: statistical_data,
      rating_data: rating_data
    }
  end
end