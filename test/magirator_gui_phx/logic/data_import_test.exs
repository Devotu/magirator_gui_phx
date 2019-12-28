defmodule DataImportTest do
  use ExUnit.Case

  alias MagiratorGuiPhx.Logic.DataImport

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

  test "import decks - success with nil" do
    {status, deck_id_list} = DataImport.import_decks(nil, 12) #Player Filip
    assert :ok == status
    assert Enum.empty? deck_id_list
  end

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
end