defmodule MagiratorGuiPhx.Helpers.Rating do

  def rate_all_result_summary(%{wins: _wins, draws: _draws, losses: _losses} = summary) do
    %{
      pdiff: MagiratorCalculator.calculate_summary_pdiff(summary),
      pdiff3: MagiratorCalculator.calculate_summary_pdiff_cap(summary, 3),
      pdist2positive: MagiratorCalculator.calculate_summary_pdist_positive(summary, 2),
      pdist2: MagiratorCalculator.calculate_summary_pdist(summary, 2)
    }
  end

  @doc """
  Create all types of rating for the given list of results
  Requires a map with a numeric field :place 
  """
  def rate_results(results) do    
    summary = MagiratorCalculator.summarize_places(results)

    capped_3 = 
    results
    |> MagiratorCalculator.summarize_places_by_opponent_deck()
    |> Enum.map(fn(x)-> MagiratorCalculator.calculate_summary_pdiff_cap(x, 3) end)
    |> Enum.sum()

    %{
      pdiff: MagiratorCalculator.calculate_summary_pdiff(summary),
      pdiff3: capped_3,
      pdist2positive: MagiratorCalculator.calculate_summary_pdist_positive(summary, 2),
      pdist2: MagiratorCalculator.calculate_summary_pdist(summary, 2)
    }
  end
end