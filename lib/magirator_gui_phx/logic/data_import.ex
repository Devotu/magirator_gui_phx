defmodule MagiratorGuiPhx.Logic.DataImport do #Data to avoid conflicts with reserved word import
  alias MagiratorStore.Structs.Deck
  alias MagiratorStore.Structs.Result
  alias MagiratorStore.Structs.Game
  alias MagiratorGuiPhxWeb.Helpers.Helper
  alias MagiratorGuiPhx.Helpers.Tier

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
    IO.inspect(data, label: "import decks invalid data #{Kernel.inspect(data)}")
    {:error, :invalid_data}
  end


  def import_deck(deck_data, player_id) when is_map deck_data do
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


  def import_game(game_data, deck_lookup) when is_map game_data do

    tags = find_tags(game_data["tags"])

    {d1, p1} = deck_lookup[game_data["d1"]]

    game = %Game{
      conclusion: game_data["cc"], 
      tags: tags,
      creator_id: p1
    }

    {:ok, game_id} = MagiratorStore.create_game(game)

    first_result = %Result{
        game_id: game_id,
        player_id: p1,
        deck_id: d1,
        place: game_data["p1"]
      }

    {:ok, _first_result_id} = MagiratorStore.add_result(first_result)


    {d2, p2} = deck_lookup[game_data["d2"]]

    second_result = %Result{
        game_id: game_id,
        player_id: p2,
        deck_id: d2,
        place: game_data["p2"]
      }

    {:ok, _second_result_id} = MagiratorStore.add_result(second_result)

    {:ok, _result} = Tier.resolve_tier_change(tags, first_result, second_result)
    
    {:ok, game_id}
  end

  def import_game(data, _deck_lookup) do
    IO.inspect(data, label: "import deck invalid data #{Kernel.inspect(data)}")
    {:error, :invalid_data}
  end

  defp num_to_bool(1), do: :true
  defp num_to_bool(0), do: :false
  defp num_to_bool(nil), do: :false

  defp find_tags(nil), do: []
  defp find_tags(tag_data) when is_list tag_data do 
    String.split(tag_data, ",")
  end
  defp find_tags(_tag_data), do: []
end
