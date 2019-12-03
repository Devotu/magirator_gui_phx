defmodule MagiratorGuiPhxWeb.ComponentView do
  use MagiratorGuiPhxWeb, :view

  alias MagiratorStore

  def select_player(form, tag) do
    {:ok, players} = MagiratorStore.list_players

    selectable_players = Enum.map(players, fn p -> [key: p.name, value: p.id] end)

    select(form, tag, selectable_players, class: "input-row input-select")
  end


  def select_deck(form, tag) do
    {:ok, decks} = MagiratorStore.list_decks

    selectable_decks = Enum.map(decks, fn d -> [key: d.name, value: d.id] end)

    select(form, tag, selectable_decks, class: "input-row input-select")
  end
end