defmodule MagiratorGuiPhxWeb.StatisticsController do
  use MagiratorGuiPhxWeb, :controller

  def index(conn, _params) do

    {:ok, all_decks} = MagiratorStore.list_decks()
    color_distribution = count_colors(all_decks)

    render conn, "show.html", [
      colors_used: color_distribution, 
      ]
  end


  defp count_colors(decks) when is_list decks do
    decks
    |> MagiratorCalculator.count_color_occurances()
    |> Enum.map(fn({k, v})-> %{name: label(k), count: v} end)
  end

  defp label(atom) do
    atom
    |> Atom.to_string()
    |> String.capitalize()
  end
end