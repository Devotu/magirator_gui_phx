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


  def import_games(deck_game_summaries, player_id) when is_list deck_game_summaries do

    games = 
    deck_game_summaries
    |> Enum.reduce([], fn(dgs, acc)-> split_result_summary_to_games(dgs) ++ acc end)

    deck_lookup = create_deck_lookup(deck_game_summaries)

    games 
    |> Enum.map(fn(g) -> import_game(g, deck_lookup) end)
    |> Enum.reduce([], fn({:ok, game_id}, acc) -> acc ++ [game_id] end)
    |> Helper.ok_result()
  end

  def import_games(nil) do
    {:ok,[]}
  end

  def import_games(data, _player_id) do
    IO.inspect(data, label: "import games invalid data")
    {:error, :invalid_data}
  end


  ## Helpers ##
  defp split_result_summary_to_games(%{"d1" => deck_one, "d2" => deck_two, "w1" => w1, "w2" => w2}) do #one
    disperse_wins(w1, deck_one, deck_two) ++ disperse_wins(w2, deck_two, deck_one)
  end


  defp disperse_wins(0, _deck_win, _deck_loss) do
    []
  end

  defp disperse_wins(1, deck_win, deck_loss) do
    [%{"d1" => deck_win, "d2" => deck_loss, "p1" => 1, "p2" => 2}]
  end

  defp disperse_wins(w, deck_win, deck_loss) do
    for _n <- (w-1)..0, do: %{"d1" => deck_win, "d2" => deck_loss, "p1" => 1, "p2" => 2}
  end


  defp create_deck_lookup(result_data) do
    #Map present decks (and thus remove duplicates)
    decks_present = 
    result_data
    |> Enum.map(fn(r)->[r["d1"], r["d2"]] end)
    |> Enum.concat()
    |> Enum.uniq()
    
    #Get list of decks
    {:ok, decks} = MagiratorStore.list_decks()

    #Match with decks present
    #Find creating players
    #Merge to lookup
    decks_present
    |> Enum.map(fn(pd)-> Enum.find(decks, &(&1.name == pd)) end)
    |> Enum.map(fn(d)-> {d, MagiratorStore.get_deck_creator(d.id)} end)
    |> Enum.map(fn({d,{:ok, p}})-> {d,p} end) 
    |> Enum.reduce(%{}, fn({d, p}, acc)-> Map.put(acc, d.name, {d.id, p.id}) end)
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
