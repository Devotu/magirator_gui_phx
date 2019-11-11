defmodule MagiratorGuiPhxWeb.RatingController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorGuiPhx.Helpers.CollectorHelper, as: Collector

  def index(conn, _params) do
    {:ok, startStamp} = DateTime.now("Etc/UTC")
    {:ok, decks} = MagiratorStore.list_decks()

    ratings = 
      decks
      |> Enum.map( fn(deck) -> {deck.name, MagiratorQuery.find_deck_results(deck.id)} end)
      |> Enum.map( fn({deck_name, {:ok, results}}) -> {deck_name, results} end)   
      |> Enum.map( fn({deck_name, results}) -> %{
        deck_name: deck_name, 
        statistical_data: Collector.collect_game_statistics(results),
        rating_data: Collector.collect_rating_data(results),
        } end)

    {:ok, endStamp} = DateTime.now("Etc/UTC")
    time_taken = DateTime.diff(startStamp, endStamp)
    IO.puts("Time to calculate statistics: #{time_taken}")

    render conn, "list.html", ratings: ratings
  end

end