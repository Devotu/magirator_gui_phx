defmodule MagiratorGuiPhxWeb.RatingView do
  use MagiratorGuiPhxWeb, :view

  def red_ink(value) when value < 0 do 
    "negative"
  end 
  def red_ink(_) do 
    "positive"
  end
end