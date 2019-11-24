defmodule MagiratorGuiPhx.Helpers.Collector do

  def collect_game_statistics(results) do
    %{
      games: MagiratorCalculator.count_aggregate_games(results), 
      wins: MagiratorCalculator.count_aggregate_wins(results), 
      draws: MagiratorCalculator.count_aggregate_draws(results),
      losses: MagiratorCalculator.count_aggregate_losses(results),  
      winrate: MagiratorCalculator.calculate_aggregate_winrate(results)
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