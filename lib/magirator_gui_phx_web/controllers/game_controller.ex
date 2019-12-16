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
end