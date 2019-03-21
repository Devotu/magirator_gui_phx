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

    match = %Match{
        creator_id: atom_match.player_one_id,
        players: [atom_match.player_one_id, atom_match.player_two_id]
      }

    {conclusion, conclusion_description} = draw_conclusion atom_match
    game = %Game{
        creator_id: atom_match.player_one_id, 
        conclusion: conclusion_description
      }

    {:ok, match_id} = MagiratorStore.create_match(match)
    {:ok, game_id} = MagiratorStore.create_game(game)
    {:ok} = MagiratorStore.add_game_to_match(game_id, match_id)

    player_one_result = %Result{
        game_id: game_id,
        player_id: atom_match.player_one_id,
        deck_id: atom_match.player_one_deck_id,
        place: evaluate_place(1, atom_match.winner)
      }

    {:ok, _creator_result_id} = MagiratorStore.add_result(player_one_result)

    player_two_result = %Result{
        game_id: game_id,
        player_id: atom_match.player_two_id,
        deck_id: atom_match.player_two_deck_id,
        place: evaluate_place(2, atom_match.winner)
      }
    
    {:ok, _opponent_result_id} = MagiratorStore.add_result(player_two_result)
    
    conn
    |> redirect(to: match_path(conn, :show, match_id))
  end


  def show(conn, %{"id" => id}) do
    {:ok, match} = MagiratorStore.get_match id
    {:ok, games} = MagiratorStore.get_games_in_match id

    [first_game | _] = games

    {:ok, [player_one_result, player_two_result]} = MagiratorStore.list_results_by_game first_game.id

    {:ok, player_one} = MagiratorStore.get_player(player_one_result.player_id)
    {:ok, deck_one} = MagiratorStore.get_deck(player_one_result.deck_id)

    {:ok, player_two} = MagiratorStore.get_player(player_two_result.player_id)
    {:ok, deck_two} = MagiratorStore.get_deck(player_two_result.deck_id)

    render conn, "show.html", %{
        match: match, games: games, 
        player_one: player_one, deck_one: deck_one,
        player_two: player_two, deck_two: deck_two
      }
  end


  def add_game(conn, %{"game" => game_params}) do
    atom_game = Helpers.atomize_keys game_params

    {match_id, _} = 
      atom_game.match_id
      |> Integer.parse


    {conclusion, conclusion_description} = draw_conclusion atom_game

    game = %Game{creator_id: atom_game.player_one_id, conclusion: conclusion_description}

    {:ok, game_id} = MagiratorStore.create_game(game)
    {:ok} = MagiratorStore.add_game_to_match(game_id, match_id)

    player_one_result = %Result{
        game_id: game_id,
        player_id: atom_game.player_one_id,
        deck_id: atom_game.player_one_deck_id,
        place: evaluate_place(1, atom_game.winner)
      }

    {:ok, _creator_result_id} = MagiratorStore.add_result(player_one_result)

    player_two_result = %Result{
        game_id: game_id,
        player_id: atom_game.player_two_id,
        deck_id: atom_game.player_two_deck_id,
        place: evaluate_place(2, atom_game.winner)
      }
    
    {:ok, _opponent_result_id} = MagiratorStore.add_result(player_two_result)
    
    conn
    |> redirect(to: match_path(conn, :show, match_id))
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


  defp draw_conclusion(atom_game) do
    if atom_game.winner > 0 do
      {:victory, "VICTORY"}
    else
      {:draw, "DRAW"}
    end
  end
end