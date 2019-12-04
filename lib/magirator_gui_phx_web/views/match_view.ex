defmodule MagiratorGuiPhxWeb.MatchView do
  use MagiratorGuiPhxWeb, :view
  alias MagiratorGuiPhxWeb.ComponentView

  def winner_name(results, players) when is_list(players) do
    winning_result = Enum.find(results, fn(r)-> r.place == 1 end)

    case winning_result do
      nil ->
        "Draw"
      _ -> 
        Enum.find(players, fn(p)-> p.id == winning_result.player_id end).name
    end
  end
end