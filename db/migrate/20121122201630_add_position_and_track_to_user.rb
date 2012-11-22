class AddPositionAndTrackToUser < ActiveRecord::Migration
  def change
    add_column :positions, :user_id, :integer
    add_column :tracks, :user_id, :interger
  end
end
