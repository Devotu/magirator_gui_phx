defmodule CollectionTest do
  use ExUnit.Case

  alias MagiratorGuiPhx.Helpers.Tags
  alias MagiratorStore.Structs.Deck

  test "change" do
    assert {:ok, :changed} == Tags.resolve_tier_change([:tier], 3, 4)
  end

  test "refrain" do
    assert {:ok, :not_requested} == Tags.resolve_tier_change([], 3, 4)
    assert {:ok, :tier_mismatch} == Tags.resolve_tier_change([:tier], 1, 2)
  end

  test "fail find deck" do
    Tags.resolve_tier_change([:tier], 3, 99)
    flunk("Tags should have failed as deck 99 does not exist")
  end
end