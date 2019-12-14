defmodule MagiratorGuiPhx.Helpers.DisplayHelper do
  
  def red_ink(value) when value < 0 do 
    "negative"
  end

  def red_ink(_) do 
    "positive"
  end
  

  def wdl(value) when value == 1 do 
    "positive"
  end
  
  def wdl(value) when value >= 2 do 
    "negative"
  end

  def wdl(_) do end


  def wdlb(value) when value >= 2 do 
    "negative-backdrop"
  end

  def wdlb(value) when value == 1 do 
    "positive-backdrop"
  end

  def wdlb(_) do 
    "neutral-backdrop"
  end

  def tier(value) when value == -2, do: "bottom-backdrop"
  def tier(value) when value == -1, do: "below-backdrop"
  def tier(value) when value == 0, do: "mid-backdrop"
  def tier(value) when value == 1, do: "above-backdrop"
  def tier(value) when value == 2, do: "top-backdrop"
end