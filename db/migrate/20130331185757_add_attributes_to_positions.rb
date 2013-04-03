class AddAttributesToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :speed, :float
    add_column :positions, :height, :float
    add_column :positions, :angle, :float
    remove_column :tracks, :speed
  end
end
