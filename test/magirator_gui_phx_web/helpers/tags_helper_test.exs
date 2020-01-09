defmodule TagsHelperTest do
  use ExUnit.Case

  alias MagiratorGuiPhx.Helpers.Tags
  alias MagiratorStore.Structs.Deck

  test "collect - tier" do
    assert [:tier] == Tags.collect_tags(%{tier: :true})
  end

  test "collect - none" do
    assert [] == Tags.collect_tags(%{})
  end
end