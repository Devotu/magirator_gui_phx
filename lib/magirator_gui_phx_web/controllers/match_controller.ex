defmodule MagiratorGuiPhxWeb.MatchController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorStore.Structs.Match
  alias MagiratorStore.Structs.Game
  alias MagiratorStore.Structs.Result
  alias MagiratorStore.Helpers

  def new(conn, _params) do
    render conn, "new.html"
  end


  def create(conn, %{"match" => match_params}) do
    atom_match = Helpers.atomize_keys match_params

    match = %Match{creator_id: atom_match.player_one_id}

    {conclusion, conclusion_description} = draw_conclusion atom_match
    game = %Game{creator_id: atom_match.player_one_id, conclusion: conclusion_description}

    {:ok, match_id} = MagiratorStore.create_match(match)
    {:ok, game_id} = MagiratorStore.create_game(game)
    {:ok} = MagiratorStore.add_game_to_match(game_id, match_id)

    first_result = %Result{
        game_id: game_id,
        player_id: atom_match.player_one_id,
        deck_id: atom_match.player_one_deck_id,
        place: evaluate_place(1, atom_match.winner)
      }

    {:ok, _creator_result_id} = MagiratorStore.add_result(first_result)

    second_result = %Result{
        game_id: game_id,
        player_id: atom_match.player_two_id,
        deck_id: atom_match.player_two_deck_id,
        place: evaluate_place(2, atom_match.winner)
      }
    
    {:ok, _opponent_result_id} = MagiratorStore.add_result(second_result)
    
    conn
    |> redirect(to: match_path(conn, :show, match_id))
  end


  def show(conn, %{"id" => id}) do
    {:ok, match} = MagiratorStore.get_match id
    {:ok, games} = MagiratorStore.get_games_in_match id
    render conn, "show.html", %{match: match, games: games}
  end


  defp evaluate_place(player, winner) do
    case winner do
      player ->
        1
      0 -> 
        0
      _ -> 2
    end
  end


  defp draw_conclusion(atom_match) do
    if atom_match.winner > 0 do
      {:victory, "VICTORY"}
    else
        {:draw, "DRAW"}
    end
  end
end