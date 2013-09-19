class AddAvgSpeedAndHeightDifferenceToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :avg_speed, :float
    add_column :tracks, :height_difference, :float
  end
end
