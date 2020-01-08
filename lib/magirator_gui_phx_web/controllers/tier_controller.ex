defmodule MagiratorGuiPhxWeb.TierController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorGuiPhx.Helpers.Statistics
  alias MagiratorGuiPhx.Helpers.Rating
  alias MagiratorGuiPhxWeb.Helpers.Helper

  def index(conn, _params) do
    {:ok, decks} = MagiratorStore.list_decks()

    tiers = Helper.clock([decks], &build_tiers/1, "Tiers")

    render conn, "show.html", [actual_tiers: tiers, calculated_tiers: tiers]
  end

  def build_tiers(decks) do
    decks
    |> Enum.map( fn(deck) -> {deck, MagiratorQuery.list_deck_results(deck.id)} end)
    |> Enum.map( fn({deck, {:ok, results}}) -> {deck, results} end)  
    |> Enum.filter( fn({_deck, results}) -> !Enum.empty? results end)
    |> Enum.map( fn({deck, results}) -> convert_to_tier_results(deck, results) end)
    |> Enum.concat()
    |> Helper.pipe_clock(&MagiratorCalculator.trace_tier/1, "Trace")
    |> Enum.map( fn({deck_id, result}) -> merge_with_deck(deck_id, result, decks) end)
    |> Enum.sort( &(&1.result.tier > &2.result.tier))
  end

  defp convert_to_tier_results(deck, results) do
    Enum.map(results, fn(result) -> %{
      game_id: result.game_id, 
      deck_id_first: deck.id, 
      place_first: result.place, 
      deck_id_second: result.opponent_deck_id, 
      place_second: infer_opponent_place(result.place)
      } end)
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
end