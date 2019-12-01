defmodule MagiratorGuiPhx.Helpers.Rating do

  @doc """
  Summarizes a list of result maps
  Requires the map to contain a field :place 
  """
  def rate_all_result_summary(%{wins: wins, draws: draws, losses: losses} = summary) do
    %{
      pdiff: MagiratorCalculator.calculate_summary_pdiff(summary),
      pdiff3: MagiratorCalculator.calculate_summary_pdiff_cap(summary, 3),
      pdist2positive: MagiratorCalculator.calculate_summary_pdist_positive(summary, 2),
      pdist2: MagiratorCalculator.calculate_summary_pdist(summary, 2)
    }
  end

  def collect_rating_data(results) do    
    %{
      pdiff: MagiratorCalculator.calculate_aggregate_pdiff(results),
      pdiff3: MagiratorCalculator.calculate_aggregate_pdiff_cap(results, 3),
      pdist2positive: MagiratorCalculator.calculate_aggregate_pdist_positive(results, 2),
      pdist2: MagiratorCalculator.calculate_aggregate_pdist(results, 2)
    }
  end
end