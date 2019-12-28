defmodule MagiratorGuiPhxWeb.MatchController do
  use MagiratorGuiPhxWeb, :controller
  alias MagiratorStore.Structs.Match
  alias MagiratorStore.Structs.Game
  alias MagiratorStore.Structs.Result
  alias MagiratorStore.Structs.Participant
  alias MagiratorGuiPhxWeb.Helpers.Helper
  alias MagiratorGuiPhx.Helpers.Tags
  alias MagiratorGuiPhx.Helpers.Tier

  def new(conn, _params) do
    render conn, "new.html"
  end


  def create(conn, %{"match" => match_params}) do
    atom_match = Helper.atomize_keys match_params
    tags = Tags.collect_tags(atom_match)
    IO.inspect(tags, label: "match tags")

    match = %Match{
      creator_id: atom_match.player_one_id,
      tags: tags
    }

    {:ok, match_id} = MagiratorStore.create_match(match)

    participant_one = %Participant{
        player_id: atom_match.player_one_id, 
        deck_id: atom_match.player_one_deck_id, 
        number: 1
      }

    {:ok, _participant_id} = MagiratorStore.create_participant(participant_one, match_id)

    participant_two = %Participant{
        player_id: atom_match.player_two_id, 
        deck_id: atom_match.player_two_deck_id, 
        number: 2
      }

    {:ok, _participant_id} = MagiratorStore.create_participant(participant_two, match_id)
    
    conn
    |> redirect(to: match_path(conn, :show, match_id))
  end


  def show(conn, %{"id" => match_id}) do
    {:ok, match} = MagiratorStore.get_match( match_id )

    {:ok, [participant_one, participant_two]} = MagiratorStore.list_participants_by_match( match_id )

    {:ok, player_one} = MagiratorStore.get_player( participant_one.player_id )
    {:ok, deck_one} = MagiratorStore.get_deck( participant_one.deck_id )

    {:ok, player_two} = MagiratorStore.get_player( participant_two.player_id )
    {:ok, deck_two} = MagiratorStore.get_deck( participant_two.deck_id )

    {:ok, games} = MagiratorStore.get_games_in_match( match_id )

    game_results = Enum.map( games, fn(game) -> 
      %{ game: game, results: Helper.expect_ok( MagiratorStore.list_results_by_game( game.id ) ) } 
    end)

    render conn, "show.html", %{
        match: match, game_results: game_results, 
        player_one: player_one, deck_one: deck_one,
        player_two: player_two, deck_two: deck_two,
        players: [player_one, player_two],
      }
  end


  def add_game(conn, %{"game" => game_params}) do
    atom_game = Helper.atomize_keys game_params
    tags = Tags.collect_tags(atom_game)
    IO.inspect(game_params)
    IO.inspect(atom_game)
    IO.inspect(tags)

    {match_id, _} = 
      atom_game.match_id
      |> Integer.parse

    {winner_number, _} = 
      atom_game.winner
      |> Integer.parse

    {_conclusion, conclusion_description} = draw_conclusion( winner_number )

    game = %Game{creator_id: atom_game.player_one_id, conclusion: conclusion_description, tags: tags}
    IO.inspect(game)

    {:ok, game_id} = MagiratorStore.create_game(game)
    {:ok} = MagiratorStore.add_game_to_match(game_id, match_id)

    player_one_result = %Result{
        game_id: game_id,
        player_id: atom_game.player_one_id,
        deck_id: atom_game.player_one_deck_id,
        place: evaluate_place(1, winner_number)
      }

    {:ok, _creator_result_id} = MagiratorStore.add_result(player_one_result)

    player_two_result = %Result{
        game_id: game_id,
        player_id: atom_game.player_two_id,
        deck_id: atom_game.player_two_deck_id,
        place: evaluate_place(2, winner_number)
      }
    
    {:ok, _opponent_result_id} = MagiratorStore.add_result(player_two_result)

    {:ok, _result} = Tier.resolve_tier_change(tags, player_one_result, player_two_result)

    conn
    |> redirect(to: match_path(conn, :show, match_id))
  end


  defp evaluate_place(_participant, 0) do
    0
  end

  defp evaluate_place(participant, winner) do
    case winner == participant do
      :true ->
        1
      _ -> 2
    end
  end


  defp draw_conclusion(winner) do
    if winner > 0 do
      {:victory, "VICTORY"}
    else
      {:draw, "DRAW"}
    end
  end


  def delete(conn, %{"id" => match_id, "caller_id" => caller_id, "caller" => caller}) do
    {:ok} = MagiratorStore.delete_match( match_id )

    case Helper.caller_as_atom(caller) do
      :deck ->
        conn
        |> redirect(to: deck_path(conn, :show, caller_id))
    end
  end
end