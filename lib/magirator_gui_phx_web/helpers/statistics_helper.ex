defmodule MagiratorGuiPhx.Helpers.Statistics do

  @doc """
  Summarizes a list of result maps
  Requires a map to contain three numeric fields wins, draws and losses
  """
  def summarize_result_summary(%{wins: wins, draws: draws, losses: losses} = summary) do
    %{
      games: wins + draws + losses, 
      wins: wins, 
      draws: draws,
      losses: losses,  
      winrate: MagiratorCalculator.calculate_summary_winrate(summary)
    }
  end

  @doc """
  Summarizes a list of result maps
  Requires a map with a numeric field :place 
  """
  def summarize_results(results) do    
    results 
    |> MagiratorCalculator.summarize_places()
    |> summarize_result_summary()
  end
end