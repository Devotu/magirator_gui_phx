defmodule MagiratorGuiPhx.Helpers.DisplayHelper do
  
  def red_ink(value) when value < 0 do 
    "negative"
  end

  def red_ink(_) do 
    "positive"
  end
end