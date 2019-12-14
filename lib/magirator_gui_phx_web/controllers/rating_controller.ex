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

    tiers =
      decks
      |> Enum.map( fn(deck) -> {deck, MagiratorQuery.list_deck_results(deck.id)} end)
      |> Enum.map( fn({deck, {:ok, results}}) -> {deck, results} end)  
      |> Enum.filter( fn({_deck, results}) -> !Enum.empty? results end)
      |> Enum.map( fn({deck, results}) -> convert_to_tier_results(deck, results) end)
      |> Enum.concat()
      |> MagiratorCalculator.trace_tier()
      |> Enum.map( fn({deck_id, result}) -> merge_with_deck(deck_id, result, decks) end)

    IO.puts(Kernel.inspect(tiers))

    render conn, "show.html", ratings: ratings, tiers: tiers
  end

  defp convert_to_tier_results(deck, results) do
    Enum.map(results, fn(result) -> %{game_id: result.game_id, deck_id_first: deck.id, place_first: result.place, deck_id_second: result.opponent_deck_id, place_second: infer_opponent_place(result.place)} end)
  end

  defp infer_opponent_place(place_self) do
    case place_self do
      0 -> 0
      1 -> 2
      _ -> 1
    end
  end

  defp merge_with_deck(deck_id, result, decks) do
    %{
      deck: Enum.find(decks, fn(d) -> d.id == deck_id end),
      result: result
    }
  end

  # {{"Deck 3", 22}, [%{game_id: 40, match_id: 0, opponent_deck_id: 20, opponent_deck_name: "Deck 1", opponent_name: "Erlango", place: 2}]}

            #  40                22               2                 20               !2->1
  #%{game_id: 1, deck_id_first: 1, place_first: 1, deck_id_second: 2, place_second: 2}   # +1  0: -1  0:  0  0:  0  0:  0  0:  0  0
end