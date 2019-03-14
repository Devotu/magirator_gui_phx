defmodule MagiratorGuiPhxWeb.RatingController do
  use MagiratorGuiPhxWeb, :controller

  def index(conn, _params) do

    {:ok, decks} = MagiratorStore.list_decks()

    ratings = 
      decks
      |> Enum.map( fn(deck) -> {deck.name, MagiratorStore.list_results_by_deck(deck.id)} end)
      |> Enum.map( fn({deck_name, {:ok, results}}) -> {deck_name, results} end)
      |> Enum.map( fn({deck_name, results}) -> %{
        deck_name: deck_name, 
        games: length(results),
        pdiff: MagiratorCalculator.calculate_pdiff(results),
        winrate: MagiratorCalculator.calculate_winrate(results)
        } end)
      |> Enum.sort(&(&1.winrate >= &2.winrate))

    render conn, "list.html", ratings: ratings
  end

end