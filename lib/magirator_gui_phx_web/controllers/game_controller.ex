defmodule MagiratorGuiPhxWeb.GameController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorStore.Structs.Game
  alias MagiratorStore.Structs.Result
  alias MagiratorStore.Helpers
  alias MagiratorGuiPhx.Helpers.Tags

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"game" => game_params}) do
    atom_game = Helpers.atomize_keys game_params
    tags = Tags.collect_tags(atom_game)
    game_data_with_tags = Map.put(atom_game, :tags, tags)
    game = struct(Game, game_data_with_tags)

    {:ok, game_id} = MagiratorStore.create_game(game)

    creator_result = %Result{
        game_id: game_id,
        player_id: game_params["creator_id"],
        deck_id: game_params["creator_deck_id"],
        place: creator_place(game_params["conclusion"]),
        comment: game_params["comment"]
      }

    {:ok, _creator_result_id} = MagiratorStore.add_result(creator_result)

    opponent_result = %Result{
        game_id: game_id,
        player_id: game_params["opponent_id"],
        deck_id: game_params["opponent_deck_id"],
        place: opponent_place(game_params["conclusion"]),
        comment: game_params["comment"]
      }

    {:ok, _opponent_result_id} = MagiratorStore.add_result(opponent_result)

    {:ok, _result} = resolve_tier_change(tags, creator_result, opponent_result)
    
    conn
    |> redirect(to: main_path(conn, :main))
  end


  defp creator_place(conclusion) do
    case conclusion do
      "victory" ->
        1
      "defeat" ->
        2
      "draw" ->
        0
      _ -> 
        -1
    end
  end

  defp opponent_place(conclusion) do
    case conclusion do
      "victory" ->
        2
      "defeat" ->
        1
      "draw" ->
        0
      _ -> 
        -1
    end
  end

  defp resolve_tier_change([:tier], result_one, result_two) do
    {:ok, deck_one} = MagiratorStore.get_deck(result_one.deck_id)  
    {:ok, deck_two} = MagiratorStore.get_deck(result_two.deck_id)

    id_corrected_result_one = Map.put(result_one, :deck_id, deck_one.id)
    id_corrected_result_two = Map.put(result_two, :deck_id, deck_two.id)

    updated_tiers = MagiratorCalculator.resolve_tier_change(deck_one, id_corrected_result_one, deck_two, id_corrected_result_two)
    MagiratorStore.update_deck_tier(deck_one.id, updated_tiers[deck_one.id])
    MagiratorStore.update_deck_tier(deck_two.id, updated_tiers[deck_two.id])

    {:ok, :changed}
  end

  defp resolve_tier_change([], _result_one, _result_two) do
    {:ok, :not_requested}
  end
end