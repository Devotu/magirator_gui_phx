defmodule MagiratorGuiPhxWeb.DeckView do
  use MagiratorGuiPhxWeb, :view

  alias MagiratorStore

  def player_select(form, tag) do
    {:ok, players} = MagiratorStore.list_players

    selectable_players = Enum.map(players, fn p -> [key: p.name, value: p.id] end)

    select(form, tag, selectable_players)
  end
end