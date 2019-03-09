defmodule MagiratorGuiPhxWeb.GameView do
  use MagiratorGuiPhxWeb, :view

  alias MagiratorStore

  def player_select(form, tag) do
    {:ok, players} = MagiratorStore.list_players

    selectable_players = Enum.map(players, fn p -> [key: p.name, value: p.id] end)

    select(form, tag, selectable_players)
  end

  def deck_select(form, tag) do
    {:ok, decks} = MagiratorStore.list_decks

    selectable_decks = Enum.map(decks, fn d -> [key: d.name, value: d.id] end)

    select(form, tag, selectable_decks)
  end
end