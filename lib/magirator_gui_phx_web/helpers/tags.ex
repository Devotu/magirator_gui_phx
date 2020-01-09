defmodule MagiratorGuiPhx.Helpers.Tags do

  def collect_tags(data) when is_map data do
    [] ++ tier(data)
  end

  defp tier(%{tier: :true}), do: [:tier]
  defp tier(%{tier: "true"}), do: [:tier]
  defp tier(%{tier: :false}), do: []
  defp tier(%{tier: "false"}), do: []
  defp tier(_), do: []


  def convert_tags(data) when is_bitstring data do
    data
    |> split_tags()
    |> Enum.map(&convert_tag/1)
    |> list_tag()
    |> Enum.concat()
  end


  defp split_tags(data) when is_bitstring data do 
    String.split(data, ",")
  end

  defp convert_tag("TIER"), do: :tier
  defp convert_tag("ARENA"), do: :arena

  defp list_tag(tag), do: [tag]
end
