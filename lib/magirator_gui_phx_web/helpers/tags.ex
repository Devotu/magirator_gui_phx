defmodule MagiratorGuiPhx.Helpers.Tags do

  def collect_tags(game_data) do
    [] ++ tier(game_data.tier)
  end

  defp tier(:true), do: [:tier]
  defp tier("true"), do: [:tier]
  defp tier(:false), do: []
  defp tier("false"), do: []
end
