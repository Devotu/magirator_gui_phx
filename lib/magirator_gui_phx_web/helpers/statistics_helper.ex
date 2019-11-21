defmodule MagiratorGuiPhx.Helpers.StatisticsHelper do

  @doc """
  Summarizes a list of result maps
  Requires the map to contain a field :place 
  """
  def summarize_result_summary(summary) do
    %{wins: wins, draws: draws, losses: losses} = summary

    %{
      games: wins + draws + losses, 
      wins: wins, 
      draws: draws,
      losses: losses,  
      winrate: MagiratorCalculator.calculate_summary_winrate(summary)
    }
  end
end