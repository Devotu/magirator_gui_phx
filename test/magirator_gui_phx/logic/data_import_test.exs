defmodule DataImportTest do
  use ExUnit.Case

  alias MagiratorGuiPhx.Logic.DataImport

  @tag deck: true
  test "import deck - success" do
    {status, id} = DataImport.import_deck(%{
      "black" => 0,
      "blue" => 1,
      "format" => "Block",
      "green" => 0,
      "name" => "Exile",
      "player" => "Kent",
      "red" => 0,
      "white" => 1
    }, 
    11) #Player Erik

    assert :ok == status
    assert is_number id
  end


  @tag deck: true
  test "import decks - success with valid data" do
    decks = [
        %{
          "black" => 1,
          "blue" => 1,
          "format" => "Block",
          "green" => 0,
          "name" => "Pirat",
          "player" => "Otto",
          "red" => 0,
          "white" => 0
        },
        %{
          "black" => 0,
          "blue" => 1,
          "format" => "Block",
          "green" => 1,
          "name" => "Meerfolk",
          "player" => "Otto",
          "red" => 0,
          "white" => 0
        },
        %{
          "black" => 0,
          "blue" => 0,
          "format" => "Block",
          "green" => 1,
          "name" => "Dino",
          "player" => "Topias",
          "red" => 1,
          "white" => 0
        },
        %{
          "black" => 0,
          "blue" => 0,
          "format" => "Block",
          "green" => 0,
          "name" => "Element",
          "player" => "Otto",
          "red" => 1,
          "white" => 1
        }
      ]

    {status, deck_id_list} = DataImport.import_decks(decks, 12) #Player Filip
    assert :ok == status
    assert is_number List.first(deck_id_list)
  end

  @tag deck: true
  test "import decks - success with nil" do
    {status, deck_id_list} = DataImport.import_decks(nil, 12) #Player Filip
    assert :ok == status
    assert Enum.empty? deck_id_list
  end

  @tag deck: true
  test "import decks - failure" do
    single_deck_object = %{
          "black" => 1,
          "blue" => 1,
          "format" => "Block",
          "green" => 0,
          "name" => "Pirat",
          "player" => "Otto",
          "red" => 0,
          "white" => 0
        }

    {status, msg} = DataImport.import_decks(single_deck_object, 12) #Player Filip
    assert :error == status
    assert :invalid_data == msg
  end



  # @tag game: true
  test "import game - success" do
    {status, id} = DataImport.import_game(
      %{"d1" => "Deck 1", "d2" => "Deck 4", "p1" => 2, "p2" => 1
      }, 
      %{
        "Deck 4" => {23, 11}, #Player "Erik"
        "Deck 1" => {20, 10}, #Player "Erlango"
        "Deck 3" => {22, 11}  #Player "Erik"
      }
    )

    assert :ok == status
    assert is_number id
  end

  
  @tag game: true
  test "import games - success with valid data" do
    games = [
        %{"d1" => "Deck 1", "d2" => "Deck 2", "w1" => 4, "w2" => 1},
        %{"d1" => "Deck 1", "d2" => "Deck 3", "w1" => 1, "w2" => 2}
      ]

    {status, game_id_list} = DataImport.import_games(games, 12) #Player Filip
    assert :ok == status
    assert is_number List.first(game_id_list)
    assert 8 == Enum.count(game_id_list)
  end
  
  @tag game: true
  test "import games - success with valid tags" do
    games = [
        %{"d1" => "Deck 1", "d2" => "Deck 2", "w1" => 4, "w2" => 1, "tags" => "TIER, ARENA"},
        %{"d1" => "Deck 1", "d2" => "Deck 3", "w1" => 1, "w2" => 2, "tags" => "TIER"}
      ]

    {status, game_id_list} = DataImport.import_games(games, 12) #Player Filip
    IO.inspect(game_id_list)
    assert :ok == status
    assert is_number List.first(game_id_list)
    assert 8 == Enum.count(game_id_list)
    assert ["TIER", "ARENA"] == MagiratorStore.get_game(List.first(game_id_list))
    assert ["TIER"] == MagiratorStore.get_game(List.last(game_id_list))
  end

  @tag game: true
  test "import games - success with nil" do
    {status, game_id_list} = DataImport.import_games(nil, 12) #Player Filip
    assert :ok == status
    assert Enum.empty? game_id_list
  end
end