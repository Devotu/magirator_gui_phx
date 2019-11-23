defmodule MagiratorGuiPhx.Helpers.CollectionHelper do

  def group_list_results_by_match(results) do
    results
    |> Enum.group_by(fn x -> x.match_id end)
    |> Enum.reduce([], fn {_key, [h|t]}, acc ->
      acc ++ [
        %{
          match_id: h.match_id, 
          opponent_deck_id: h.opponent_deck_id,
          opponent_deck_name: h.opponent_deck_name,
          opponent_name: h.opponent_name,
          results: [h] ++ t
        }
      ]
    end)
  end

  def match_wdl(match) do
    wins = Enum.count(match.results, &(&1.place == 1))
    losses = Enum.count(match.results, &(&1.place > 1))

    case {wins > losses, wins < losses} do
      {true, _} ->
        1
      {_, true} ->
        2
      _ -> 
        0        
    end            
  end
end
