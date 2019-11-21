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
end
