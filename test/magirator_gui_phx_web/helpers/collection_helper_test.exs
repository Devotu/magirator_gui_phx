defmodule CollectionHelperTest do
  use ExUnit.Case

  alias MagiratorGuiPhx.Helpers.CollectionHelper, as: Collection

  test "group list results by match" do
    results = [
        %{match_id: 1, opponent_name: "Adam", opponent_deck_id: 10, opponent_deck_name: "Deck1", game_id: 1},
        %{match_id: 1, opponent_name: "Adam", opponent_deck_id: 10, opponent_deck_name: "Deck1", game_id: 2},
        %{match_id: 2, opponent_name: "Bertil", opponent_deck_id: 11, opponent_deck_name: "Deck2", game_id: 3},
        %{match_id: 2, opponent_name: "Bertil", opponent_deck_id: 11, opponent_deck_name: "Deck2", game_id: 4},
        %{match_id: 3, opponent_name: "Adam", opponent_deck_id: 12, opponent_deck_name: "Deck3", game_id: 5},
        %{match_id: 2, opponent_name: "Bertil", opponent_deck_id: 11, opponent_deck_name: "Deck2", game_id: 6},
      ]

      grouped = Collection.group_list_results_by_match(results)
      first = List.first grouped

      assert is_list grouped 
      assert 3 == Enum.count grouped
      assert is_map first
      assert Map.has_key? first, :match_id
      assert !is_nil first.match_id
      assert Map.has_key? first, :opponent_name
      assert !is_nil first.opponent_name
      assert Map.has_key? first, :results
      assert Map.has_key? List.first(first.results), :game_id
    end


    test "match_wdl - win" do
      match = %{
        match_id: 0,
        opponent_deck_id: 20,
        opponent_deck_name: "Deck 1",
        opponent_name: "Erlango",
        results: [
          %{
            game_id: 46,
            match_id: 0,
            opponent_deck_id: 20,
            opponent_deck_name: "Deck 1",
            opponent_name: "Erlango",
            place: 1
          },
          %{
            game_id: 45,
            match_id: 0,
            opponent_deck_id: 20,
            opponent_deck_name: "Deck 1",
            opponent_name: "Erlango",
            place: 2
          },
          %{
            game_id: 44,
            match_id: 0,
            opponent_deck_id: 20,
            opponent_deck_name: "Deck 1",
            opponent_name: "Erlango",
            place: 1
          }
        ]
      }

      assert 1 == Collection.match_wdl match
    end

    test "match_wdl - draw" do
      match = %{
        match_id: 0,
        opponent_deck_id: 20,
        opponent_deck_name: "Deck 1",
        opponent_name: "Erlango",
        results: [
          %{
            game_id: 45,
            match_id: 0,
            opponent_deck_id: 20,
            opponent_deck_name: "Deck 1",
            opponent_name: "Erlango",
            place: 2
          },
          %{
            game_id: 44,
            match_id: 0,
            opponent_deck_id: 20,
            opponent_deck_name: "Deck 1",
            opponent_name: "Erlango",
            place: 1
          }
        ]
      }

      assert 0 == Collection.match_wdl match
    end

    test "match_wdl - loss" do
      match = %{
        match_id: 0,
        opponent_deck_id: 20,
        opponent_deck_name: "Deck 1",
        opponent_name: "Erlango",
        results: [
          %{
            game_id: 46,
            match_id: 0,
            opponent_deck_id: 20,
            opponent_deck_name: "Deck 1",
            opponent_name: "Erlango",
            place: 2
          },
          %{
            game_id: 45,
            match_id: 0,
            opponent_deck_id: 20,
            opponent_deck_name: "Deck 1",
            opponent_name: "Erlango",
            place: 2
          },
          %{
            game_id: 44,
            match_id: 0,
            opponent_deck_id: 20,
            opponent_deck_name: "Deck 1",
            opponent_name: "Erlango",
            place: 1
          }
        ]
      }

      assert 2 == Collection.match_wdl match
    end
  end