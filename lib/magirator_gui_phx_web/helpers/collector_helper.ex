defmodule MagiratorGuiPhx.Helpers.CollectorHelper do

  def collect_game_statistics(results) do
    %{
      games: MagiratorCalculator.count_games(results), 
      wins: MagiratorCalculator.count_wins(results), 
      draws: MagiratorCalculator.count_draws(results),
      losses: MagiratorCalculator.count_losses(results),  
      winrate: MagiratorCalculator.calculate_winrate(results)
    }
  end

  def collect_rating_data(results) do    
    %{
      pdiff: MagiratorCalculator.calculate_pdiff(results),
      pdiff3: MagiratorCalculator.calculate_pdiff_cap(results, 3),
      pdist2positive: MagiratorCalculator.calculate_pdist_positive(results, 2),
      pdist2: MagiratorCalculator.calculate_pdist(results, 2)
    }
  end
end