defmodule MagiratorGuiPhxWeb.RatingController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorStore.Structs.Deck
  alias MagiratorStore.Helpers

  def index(conn, _params) do

    {:ok, decks} = MagiratorStore.list_decks()

    ratings = 
      decks
      |> Enum.map( fn(deck) -> {deck.name, MagiratorStore.list_results_by_deck(deck.id)} end)
      |> Enum.map( fn({deck_name, {:ok, results}}) -> {deck_name, results} end)
      |> Enum.map( fn({deck_name, results}) -> %{deck_name: deck_name, points: MagiratorCalculator.calculate_points(results)} end)

    render conn, "list.html", ratings: ratings
  end

end