defmodule MagiratorGuiPhxWeb.StatisticsController do
  use MagiratorGuiPhxWeb, :controller

  def index(conn, _params) do

    {:ok, all_decks} = MagiratorStore.list_decks()

    render conn, "show.html", [
      colors_used: count_colors(all_decks), 
      color_combinations: count_color_combinations(all_decks)
      ]
  end


  defp count_colors(decks) when is_list decks do
    decks
    |> MagiratorCalculator.count_color_occurances()
    |> Enum.map(fn({k, v})-> %{name: label(k), count: v} end)
  end


  defp count_color_combinations(decks) when is_list decks do
    decks
    |> MagiratorCalculator.count_color_combinations()
    |> Enum.map(fn(%{count: count, colors: colors})-> format_color_info(colors, count) end)
    |> IO.inspect()
    |> Enum.reduce(%{monos: [], duals: [], triplets: [], quads: [], pentas: [], others: []}, fn(combination, m)-> categorize_combination(combination, m) end)
    |> IO.inspect()
  end


  defp categorize_combination(%{fifth: _c} = combination_package, combination_map) do
    Map.put(combination_map, :pentas, combination_map.pentas ++ [combination_package])
  end
  defp categorize_combination(%{fourth: _c} = combination_package, combination_map) do
    Map.put(combination_map, :quads, combination_map.quads ++ [combination_package])
  end
  defp categorize_combination(%{third: _c} = combination_package, combination_map) do
    Map.put(combination_map, :triplets, combination_map.triplets ++ [combination_package])
  end
  defp categorize_combination(%{second: _c} = combination_package, combination_map) do
    Map.put(combination_map, :duals, combination_map.duals ++ [combination_package])
  end
  defp categorize_combination(%{first: _c} = combination_package, combination_map) do
    Map.put(combination_map, :monos, combination_map.monos ++ [combination_package])
  end
  defp categorize_combination(combination_package, combination_map) do
    Map.put(combination_map, :others, combination_map.others ++ [combination_package])
  end


  defp format_color_info({first}, count) do
    %{count: count, first: label(first)}
  end
  defp format_color_info({first, second}, count) do
    %{count: count, first: label(first), second: label(second)}
  end
  defp format_color_info({first, second, third}, count) do
    %{count: count, first: label(first), second: label(second), third: label(third)}
  end
  defp format_color_info({first, second, third, fourth}, count) do
    %{count: count, first: label(first), second: label(second), third: label(third), fourth: label(fourth)}
  end
  defp format_color_info({first, second, third, fourth, fifth}, count) do
    %{count: count, first: label(first), second: label(second), third: label(third), fourth: label(fourth), fifth: label(fifth)}
  end
  defp format_color_info(colors, count) do
    %{count: count, first: label(:other)}
  end


  defp label(atom) do
    atom
    |> Atom.to_string()
    |> String.capitalize()
  end
end