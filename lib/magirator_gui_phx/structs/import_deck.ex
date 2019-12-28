defmodule MagiratorGuiPhx.Structs.ImportDeck do
  
  defstruct(
    name:   "",
    theme:  "",
    format: "",
    black:  :false,
    white:  :false,
    red:  :false,
    green:  :false,
    blue:  :false,
    colorless:  :false
  )

  def map_has_valid_values?(%{} = _map) do
    :true
  end

  def map_has_valid_values?(_) do
    :false
  end
end