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
  end