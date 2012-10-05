class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.float :longitude
      t.float :latitude
      t.integer :track_id

      t.timestamps
    end
  end
end
