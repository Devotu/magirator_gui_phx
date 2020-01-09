defmodule MagiratorGuiPhx.Logic.DataImport do #Data to avoid conflicts with reserved word import
  alias MagiratorStore.Structs.Deck
  alias MagiratorStore.Structs.Result
  alias MagiratorStore.Structs.Game
  alias MagiratorGuiPhxWeb.Helpers.Helper
  alias MagiratorGuiPhx.Helpers.Tier
  alias MagiratorGuiPhx.Helpers.Tags

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


  def import_game(game_data, deck_lookup, creator_id) when is_map game_data do

    tags = find_tags(game_data)

    {d1, p1} = deck_lookup[game_data["d1"]]

    game = %Game{
      conclusion: game_data["cc"], 
      tags: tags,
      creator_id: creator_id
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

  def import_game(data, _deck_lookup, _creator_id) do
    IO.inspect(data, label: "import deck invalid data #{Kernel.inspect(data)}")
    {:error, :invalid_data}
  end


  def import_games(deck_game_summaries, creator_id) when is_list deck_game_summaries do

    games = 
    deck_game_summaries
    |> Enum.reduce([], fn(dgs, acc)-> split_result_summary_to_games(dgs) ++ acc end)

    deck_lookup = create_deck_lookup(deck_game_summaries)

    games 
    |> Enum.map(fn(g) -> import_game(g, deck_lookup, creator_id) end)
    |> Enum.reduce([], fn({:ok, game_id}, acc) -> acc ++ [game_id] end)
    |> Helper.ok_result()
  end

  def import_games(nil, _player_id) do
    {:ok,[]}
  end

  def import_games(data, _player_id) do
    IO.inspect(data, label: "import games invalid data")
    {:error, :invalid_data}
  end


  ## Helpers ##
  defp split_result_summary_to_games(%{"d1" => deck_one, "d2" => deck_two, "w1" => w1, "w2" => w2, "tags" => tags}) do
    disperse_wins(w1, deck_one, deck_two, tags) ++ disperse_wins(w2, deck_two, deck_one, tags)
  end

  defp split_result_summary_to_games(%{"d1" => deck_one, "d2" => deck_two, "w1" => w1, "w2" => w2}) do
    disperse_wins(w1, deck_one, deck_two) ++ disperse_wins(w2, deck_two, deck_one)
  end

  defp disperse_wins(n, deck_win, deck_loss, tags \\ nil)
  defp disperse_wins(0, _deck_win, _deck_loss, _tags), do: []
  defp disperse_wins(1, deck_win, deck_loss, tags) do
    [%{"d1" => deck_win, "d2" => deck_loss, "p1" => 1, "p2" => 2, "tags" => tags}]
  end
  defp disperse_wins(w, deck_win, deck_loss, tags) do
    for _n <- (w-1)..0, do: %{"d1" => deck_win, "d2" => deck_loss, "p1" => 1, "p2" => 2, "tags" => tags}
  end


  defp create_deck_lookup(result_data) do
    #Map present decks (and thus remove duplicates)
    deck_names_present = 
    result_data
    |> Enum.map(fn(r)->[r["d1"], r["d2"]] end)
    |> Enum.concat()
    |> Enum.uniq()

    
    #Get list of decks
    {:ok, decks} = MagiratorStore.list_decks()

    #Match with decks present
    #Find creating players
    #Merge to lookup
    deck_names_present
    |> Enum.map(fn(n)-> match_deck(decks, n) end)
    |> Enum.map(fn(d)-> {d, MagiratorStore.get_deck_creator(d.id)} end)
    |> Enum.map(fn({d,{:ok, p}})-> {d,p} end) 
    |> Enum.reduce(%{}, fn({d, p}, acc)-> Map.put(acc, d.name, {d.id, p.id}) end)
  end

  defp match_deck(decks, name) do
    deck = Enum.find(decks, &(&1.name == name))
    case deck do
      nil ->
        IO.inspect("Could not find deck #{name}")
        name
      _ -> deck
    end    
  end

  defp num_to_bool(1), do: :true
  defp num_to_bool(0), do: :false
  defp num_to_bool(nil), do: :false

  defp find_tags(nil), do: []
  defp find_tags(%{"tags" => tags}) do
    Tags.convert_tags(tags)
  end
  defp find_tags(_data), do: []
end
