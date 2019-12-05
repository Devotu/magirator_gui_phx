defmodule MagiratorGuiPhx.Helpers.Collector do

  def collect_game_statistics(results) do
    %{
      games: MagiratorCalculator.count_summary_list_games(results), 
      wins: MagiratorCalculator.count_summary_list_wins(results), 
      draws: MagiratorCalculator.count_summary_list_draws(results),
      losses: MagiratorCalculator.count_summary_list_losses(results),  
      winrate: MagiratorCalculator.calculate_summary_list_winrate(results)
    }
  end

  def collect_rating_data(results) do    
    %{
      pdiff: MagiratorCalculator.calculate_summary_list_pdiff(results),
      pdiff3: MagiratorCalculator.calculate_summary_list_pdiff_cap(results, 3),
      pdist2positive: MagiratorCalculator.calculate_summary_list_pdist_positive(results, 2),
      pdist2: MagiratorCalculator.calculate_summary_list_pdist(results, 2)
    }
  end
end