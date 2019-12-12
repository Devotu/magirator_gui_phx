defmodule MagiratorGuiPhxWeb.RatingController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorGuiPhx.Helpers.Statistics
  alias MagiratorGuiPhx.Helpers.Rating

  def index(conn, _params) do
    {:ok, decks} = MagiratorStore.list_decks()

    ratings = 
      decks 
      |> Enum.map( fn(deck) -> {deck.name, MagiratorQuery.list_deck_results(deck.id)} end)
      |> Enum.map( fn({deck_name, {:ok, results}}) -> {deck_name, results} end)    
      |> Enum.map( fn({deck_name, results}) -> %{
          deck_name: deck_name, 
          statistical_data: Statistics.summarize_results(results),
          rating_data: Rating.rate_results(results),
        } end)

    render conn, "list.html", ratings: ratings
  end

end