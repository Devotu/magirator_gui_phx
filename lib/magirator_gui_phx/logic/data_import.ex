defmodule MagiratorGuiPhx.Logic.DataImport do #Data to avoid conflicts with reserved word import
  alias MagiratorStore.Structs.Deck
  alias MagiratorGuiPhxWeb.Helpers.Helper

  def import_decks(decks, player_id) when is_list decks do
    decks 
    |> Enum.map(fn(d) -> import_deck(d, player_id) end)
    |> Enum.reduce([], fn({:ok, deck_id}, acc) -> acc ++ [deck_id] end)
    |> Helper.ok_result()
  end

  def import_decks(nil, _player_id) do
    {:ok,[]}
  end

  def import_decks(data, _player_id) do
    IO.inspect(data, label: "import decks invalid data #{data}")
    {:error, :invalid_data}
  end


  def import_deck(%{} = deck_data, player_id) do
    deck = %Deck{
      name: deck_data["name"],
      theme: deck_data["theme"],
      format: deck_data["format"],
      black: num_to_bool(deck_data["black"]),
      white: num_to_bool(deck_data["white"]),
      red: num_to_bool(deck_data["red"]),
      green: num_to_bool(deck_data["green"]),
      blue: num_to_bool(deck_data["blue"]),
      colorless: num_to_bool(deck_data["colorless"])
    }

    MagiratorStore.create_deck(deck, player_id)
  end

  def import_deck(data, _player_id) do
    IO.inspect(data, label: "import deck invalid data #{data}")
    {:error, :invalid_data}
  end

  defp num_to_bool(1), do: :true
  defp num_to_bool(0), do: :false
  defp num_to_bool(nil), do: :false
end
