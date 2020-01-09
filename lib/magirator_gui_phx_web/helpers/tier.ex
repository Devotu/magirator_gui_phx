defmodule MagiratorGuiPhx.Helpers.Tier do

  def resolve_tier_change([:tier], result_one, result_two) do
    {:ok, deck_one} = MagiratorStore.get_deck(result_one.deck_id)  
    {:ok, deck_two} = MagiratorStore.get_deck(result_two.deck_id)

    id_corrected_result_one = Map.put(result_one, :deck_id, deck_one.id)
    id_corrected_result_two = Map.put(result_two, :deck_id, deck_two.id)

    updated_tiers = MagiratorCalculator.resolve_tier_change(deck_one, id_corrected_result_one, deck_two, id_corrected_result_two)
    MagiratorStore.update_deck_tier(deck_one.id, updated_tiers[deck_one.id])
    MagiratorStore.update_deck_tier(deck_two.id, updated_tiers[deck_two.id])

    {:ok, :changed}
  end

  def resolve_tier_change([:tier|_t], result_one, result_two) do
    resolve_tier_change([:tier], result_one, result_two)
  end

  def resolve_tier_change([_h|t], result_one, result_two) do
    resolve_tier_change(t, result_one, result_two)
  end

  def resolve_tier_change([], _result_one, _result_two) do
    {:ok, :not_requested}
  end
  

  def using_tier_i(taglist) do
    IO.inspect(using_tier(taglist), label: "using tier")
  end

  def using_tier([:tier]), do: :true
  def using_tier(_), do: :false
end
